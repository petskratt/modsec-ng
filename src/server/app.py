import os
from flask import Flask, request

app = Flask(__name__)

request_file = "REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf"
response_file = "RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf"

def get_rule_content(hostname, file):
    print("Requesting rules for hostname ", hostname, file)
    safe_dir = "/rules/"
    request_path = safe_dir + hostname
    if os.path.commonprefix((os.path.realpath(request_path),safe_dir)) != safe_dir: 
        return ""

    with open(request_path + "/" + file, 'r') as file:
        return file.read()

@app.route('/request')
def request_handler():
    hostname = request.args.get("hostname")

    default = get_rule_content("default", request_file)
    try:
        additions = get_rule_content(hostname, request_file)
    except:
        additions = ""

    return default + "\n" + additions

@app.route('/response')
def response_handler():
    hostname = request.args.get("hostname")

    default = get_rule_content("default", response_file)
    try:
        additions = get_rule_content(hostname, response_file)
    except:
        additions = ""

    return default + "\n" + additions

if __name__ == "__main__":
    app.run()