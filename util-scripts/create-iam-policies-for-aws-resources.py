def generate_tf_code(resource_access_details):
    # Mapping access levels to AWS policy actions for S3 and DynamoDB
    access_actions = {
        's3': {
            'read-write': ['s3:GetObject', 's3:PutObject', 's3:DeleteObject'],
            'read-only': ['s3:GetObject'],
            'write-only': ['s3:PutObject']
        },
        'dynamodb': {
            'read-write': ['dynamodb:GetItem', 'dynamodb:PutItem', 'dynamodb:DeleteItem'],
            'read-only': ['dynamodb:GetItem'],
            'write-only': ['dynamodb:PutItem']
        }
    }
    
    # Terraform template for IAM policy document
    tf_code = '''resource "aws_iam_policy" "example_policy" {
  name        = "example_policy"
  description = "IAM policy for S3 and DynamoDB access"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
'''
    
    # Loop through resources to add required statements
    statements = []
    for resource, details in resource_access_details.items():
        resource_type, attribute = resource.split('.')
        name = details['name']
        access = details['access']
        
        if resource_type == 's3':
            actions = access_actions['s3'].get(access, [])
            statements.append({
                "Effect": "Allow",
                "Action": actions,
                "Resource": f"arn:aws:s3:::{name}/*"
            })
        
        elif resource_type == 'dynamodb':
            actions = access_actions['dynamodb'].get(access, [])
            statements.append({
                "Effect": "Allow",
                "Action": actions,
                "Resource": f"arn:aws:dynamodb:::table/{name}"
            })
    
    # Convert statements to Terraform JSON format
    for statement in statements:
        tf_code += f'      {statement},\n'
    
    # Close the Terraform code
    tf_code += '''
    ]
  })
}
'''
    return tf_code

# Example input
resource_access_details = {
    's3.bucketname': {'name': 'abc', 'access': 'read-write'},
    'dynamo.dbName': {'name': 'example_table', 'access': 'read-only'}
}

# Generate Terraform code
tf_code = generate_tf_code(resource_access_details)
print(tf_code)
