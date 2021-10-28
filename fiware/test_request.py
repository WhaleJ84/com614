from requests import post

print(
    post(
        "http://192.168.103.233:5000/subscription/ferry-delay",
        json={
            "data": [
                {
                    "remainingTime": {
                        "value": "PT9M29S"
                    }
                }
            ]
        }
    ).content
)
