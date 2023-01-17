# Zero downtime deploy
A quick example of implementing a zero downtime deployment using the newer launch templates. Launch templates support rolling updates natively. This will result in a period of time where traffic is routed between the new and old application version.

While it is possible to use launch configurations to implement a blue-green deployment with Terraform, the [AWS documentation](https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-templates.html) recommends using launch templates in preference to the older launch configurations.
> We recommend that you use launch templates to ensure that you're accessing the latest features and improvements. Not all Amazon EC2 Auto Scaling features are available when you use launch configurations.


## How To
Create an `.auto.tfvars`, and add your variables:
```
vpc_id = "<your vpc>"
private_subnet_ids = ["<your public subnets>"]
public_subnet_ids = ["<your private subnets>"]
foo_version = 1

```

Run the usual init and apply, then curl the ALB DNS in the output.
```
$ curl foo-lb-1535605501.ap-southeast-2.elb.amazonaws.com
foo version 1
```
> **Note**
> You may have to wait a few moments for the EC2 instances to come online.


Once both instances are online, open up a new terminal, and curl the ALB DNS in a loop, eg:
```
while true; do curl foo-lb-1535605501.ap-southeast-2.elb.amazonaws.com; sleep 0.1; done
```

Return to your Terraform terminal, increment `var.foo_version`, run apply, and observe the output of your curl loop:
```
$ while true; do curl foo-lb-1535605501.ap-southeast-2.elb.amazonaws.com; sleep 0.1; done
foo version 4
foo version 4
<snip>
foo version 5
foo version 5
foo version 4
foo version 4
foo version 5
foo version 4
<snip>
foo version 5
foo version 5
foo version 5
foo version 5
foo version 5
foo version 5
foo version 5
```

🎉️


### Limitations
When there is only one instance in the Auto Scaling group, starting an instance refresh can result in an outage. This is because Amazon EC2 Auto Scaling terminates an instance and then launches a new instance.

https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-instance-refresh.html#instance-refresh-limitations
