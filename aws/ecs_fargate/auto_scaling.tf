# --- Auto Scaling Target ---
# This resource registers the ECS service's desired count as a scalable target
# with AWS Application Auto Scaling.
resource "aws_appautoscaling_target" "ecs_service_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.app_min_count
  max_capacity       = var.app_max_count
}

# --- Auto Scaling Policy: Scale Out (CPU Utilization) ---
# This policy scales up the ECS service when CPU utilization exceeds a defined threshold.
resource "aws_appautoscaling_policy" "ecs_scale_out_policy" {
  name               = "${var.app_name}-cpu-scale-out"
  service_namespace  = aws_appautoscaling_target.ecs_service_target.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_service_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    # Indicates whether the policy should disable scale-in actions.
    # Set to false to allow both scale-out and scale-in.
    disable_scale_in = false
    target_value     = var.scale_out_cpu_threshold

    predefined_metric_specification {
      # For ECS services, 'ECSServiceAverageCPUUtilization' is a common metric.
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    # Optional: Customize the scale-out and scale-in cooldown periods.
    # scale_out_cooldown = 300 # Default is 300 seconds (5 minutes)
    # scale_in_cooldown  = 600 # Default is 600 seconds (10 minutes)
  }

  depends_on = [aws_appautoscaling_target.ecs_service_target]
}

# --- Auto Scaling Policy: Scale In (CPU Utilization) ---
# This policy scales down the ECS service when CPU utilization falls below a defined threshold.
resource "aws_appautoscaling_policy" "ecs_scale_in_policy" {
  name               = "${var.app_name}-cpu-scale-in"
  service_namespace  = aws_appautoscaling_target.ecs_service_target.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_service_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  # Configuration for target tracking scaling.
  target_tracking_scaling_policy_configuration {
    # Indicates whether the policy should disable scale-in actions.
    # We want scale-in, so this should be false.
    disable_scale_in = false
    target_value     = var.scale_in_cpu_threshold

    predefined_metric_specification {
      # For ECS services, 'ECSServiceAverageCPUUtilization' is a common metric.
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    # Optional: Customize the scale-out and scale-in cooldown periods.
    # scale_out_cooldown = 300 # Default is 300 seconds (5 minutes)
    # scale_in_cooldown  = 600 # Default is 600 seconds (10 minutes)
  }

  depends_on = [aws_appautoscaling_target.ecs_service_target]
}