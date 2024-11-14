import os
import shutil

# Function to copy .tf files from source to destination
def copy_tf_files(src, dest):
    if not os.path.exists(dest):
        os.makedirs(dest)
    for file_name in os.listdir(src):
        full_file_name = os.path.join(src, file_name)
        if os.path.isfile(full_file_name) and file_name.endswith('.tf'):
            shutil.copy(full_file_name, dest)

# Main function
def main():
    # Take service-name as input
    service_name = input("Enter the service name: ")

    # Define paths
    base_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    templates_path = os.path.join(base_path, 'templates', 'deployment')
    generated_code_path = os.path.join(base_path, 'generated-code', 'terraform')
    modules_generated_code_path = os.path.join(generated_code_path, 'modules', service_name)

    # Copy .tf files from templates/deployment to generated-code/terraform
    copy_tf_files(templates_path, generated_code_path)

    # Copy .tf files from templates/deployment/modules to generated-code/terraform/modules/{service_name}
    modules_templates_path = os.path.join(templates_path, 'modules')
    copy_tf_files(modules_templates_path, modules_generated_code_path)

if __name__ == "__main__":
    main()
