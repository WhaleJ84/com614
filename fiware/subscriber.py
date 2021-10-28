from datetime import datetime, timedelta
from re import search

from flask import Flask, request, Response

app = Flask(__name__)
app.logger.setLevel("DEBUG")

app.current_time = datetime(2021, 10, 21, 16, 48, 32)
app._arrival_minutes = 30
app._arrival_seconds = 28


@app.route("/subscription/ferry-delay", methods=["POST"])
def ferry_delay():
    app.logger.info(request.json)
    new_value = str(request.json["data"][0]["remainingTime"]["value"])
    app._arrival_minutes = int(str(search(r"[0-9]*M", new_value).group())[:-1])
    app._arrival_seconds = int(str(search(r"[0-9]*S", new_value).group())[:-1])
    return Response()


@app.route("/schedule", methods=["GET"])
def schedule():
    arrival_time = app.current_time + timedelta(
        minutes=app._arrival_minutes,
        seconds=app._arrival_seconds
    )
    return Response(f"""
<p>Current Time: {app.current_time.time().isoformat()}</p><br/>
<p>Arrival Time: {arrival_time.time().isoformat()}</p><br/>
""")


if __name__ == '__main__':
    app.run(host="0.0.0.0")
