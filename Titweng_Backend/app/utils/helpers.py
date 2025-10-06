import uuid
import datetime

def generate_uuid():
    return str(uuid.uuid4())

def current_timestamp():
    return datetime.datetime.now().isoformat()
