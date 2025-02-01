import boto3
import os
import logging
import json
import urllib3

http = urllib3.PoolManager()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

ec2_client = boto3.client("ec2")
sns_client = boto3.client("sns")
secret_client = boto3.client("secretsmanager")
SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")
SLACK_SECRET_NAME = os.environ.get("SLACK_SECRET_NAME")

def lambda_handler(event, context):
    """
    AWS Lambda function to check for running EC2 instances with a specific tag and send notifications.

    This function performs the following steps:
    1. Describes EC2 instances with the tag "Name" and value pattern "temp-ad-hoc-*".
    2. Collects the instance IDs of running instances.
    3. If there are running instances, sends a notification via SNS and Slack.
    4. Logs the notification status or absence of running instances.

    Parameters:
    event (dict): AWS Lambda event data.
    context (object): AWS Lambda context object.

    Raises:
    Exception: If any error occurs during the execution of the function.
    """
    try:
        response = ec2_client.describe_instances(
            Filters=[{"Name": "tag:Name", "Values": ["temp-ad-hoc-*"]}]
        )

        running_instances = []
        for reservation in response["Reservations"]:
            for instance in reservation["Instances"]:
                if instance["State"]["Name"] == "running":
                    running_instances.append(instance["InstanceId"] + " with name " + instance["Tags"][0]["Value"])

        if running_instances:
            message = f"The following EC2 instances are still running: {', '.join(running_instances)}"
            sns_client.publish(TopicArn=SNS_TOPIC_ARN, Message=message, Subject="Temp EC2 Alert")
            response = secret_client.get_secret_value(SecretId=SLACK_SECRET_NAME)
            webhook_url = response["SecretString"]
            parsed_response = json.loads(webhook_url)
            url = parsed_response["Url"]
            msg = {
                "username": "Aws Resource Checker",
                "text": message,
            }
            encoded_msg = json.dumps(msg).encode("utf-8")
            resp = http.request("POST", url, body=encoded_msg)
            print(
                {
                    "message": msg,
                    "status_code": resp.status,
                    "response": resp.data,
                }
            )
            logger.info("Notification sent: %s", message)
        else:
            logger.info("No temporary EC2 instances running.")
    except Exception as e:
        logger.error("Error occurred: %s", str(e))
        raise