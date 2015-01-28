# Cloudformation Test

## Problems I run into

- With `AWS::EC2::SecurityGroup` resource. Specify `CidrIp` or
`SourceSecurityGroupId` for `SecurityGroupIngress` correctly.
- Choose correct `ImageId` for t2 instance. t2 instance should have an image that
has options `VirtualizationType=hvm` and `RootDeviceType=ebs`.

Following command will show a list of available images. You may specify `--region` option.

```sh
aws ec2 describe-images --owners amazon
```

If you use t2 instance for both Bastion and NAT instance, Name of the `ImageId`
should be `amzn-ami-vpc-nat-hvm-*` for NAT, `amzn-ami-hvm-*` for Bastion.

## Useful links

- <http://blogs.aws.amazon.com/application-management/post/Tx2DUJYZVBMJ92J/>