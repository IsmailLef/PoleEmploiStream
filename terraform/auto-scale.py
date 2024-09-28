import sys
import subprocess
from flask import Flask, request

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    alert_data = request.get_json()
    if alert_data['commonLabels']['alertname'] == 'HighCPUUsage':
        main(worker_to_add=1)
    elif alert_data['commonLabels']['alertname'] == 'LowCPUUsage':
        main(worker_to_add=-1)
    else:
        print("No action taken", file=sys.stderr)
    
    return "Alerte reçue", 200

def update_terraform_variable(worker_to_add):
    with open("workers.tf", 'r') as file:
        lines = file.readlines()

    new_lines = []
    search_string = f'variable "worker_count" {{'
    found = False
    for line in lines:
        if found and 'default' in line:
            old_worker_count = int(line.split('=')[1].strip())
            new_worker_count = old_worker_count + worker_to_add
            if new_worker_count < 2:
                new_worker_count = 2
            new_lines.append(f'  default     = {new_worker_count}\n')
            found = False
        else:
            new_lines.append(line)

        if search_string in line:
            found = True

    with open("workers.tf", 'w') as file:
        file.writelines(new_lines)

def run_terraform_apply():
    subprocess.run(["terraform", "apply", "-auto-approve"], check=True)

def main(worker_to_add=0):
    update_terraform_variable(worker_to_add)

    run_terraform_apply()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
