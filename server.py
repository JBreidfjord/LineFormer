import base64

import cv2
import infer
import numpy as np
import runpod

# Initialize model
CKPT = "iter_3000.pth"
CONFIG = "lineformer_swin_t_config.py"
DEVICE = "cpu"
infer.load_model(CONFIG, CKPT, DEVICE)


def run(job):
    job_input = job["input"]
    if "image" not in job_input:
        raise ValueError("Input must contain 'image'")

    # image is base64 encoded image
    img_bytes = base64.b64decode(job_input["image"])
    img = cv2.imdecode(np.frombuffer(img_bytes, np.uint8), cv2.IMREAD_COLOR)
    return infer.get_dataseries(img, to_clean=False)


runpod.serverless.start({"handler": run})
