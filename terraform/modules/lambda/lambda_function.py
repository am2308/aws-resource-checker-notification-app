import boto3
import os
import logging
import json

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

ec2_client = boto3.client("ec2")
sns_client = boto3.client("sns")
SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")

def lambda_handler(event, context):
    try:
        response = ec2_client.describe_instances(
            Filters=[{"Name": "tag:Name", "Values": ["temp-ad-hoc-*"]}]
        )

        running_instances = []
        for reservation in response["Reservations"]:
            for instance in reservation["Instances"]:
                if instance["State"]["Name"] == "running":
                    running_instances.append(instance["InstanceId"])

        if running_instances:
            message = f"The following EC2 instances are still running: {', '.join(running_instances)}"
            sns_client.publish(TopicArn=SNS_TOPIC_ARN, Message=message, Subject="Temp EC2 Alert")
            logger.info("Notification sent: %s", message)
        else:
            logger.info("No temporary EC2 instances running.")
    except Exception as e:
        logger.error("Error occurred: %s", str(e))
        raise