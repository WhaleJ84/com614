from datetime import datetime, time, timedelta
from re import search

from flask import Flask, request, Response

app = Flask(__name__)
app.logger.setLevel("DEBUG")

app.current_time = datetime(2021, 10, 21, 16, 48, 32)
app._arrival_minutes = 27
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
    if arrival_time.time() <= time(17, 20):
        return Response(f"""
<p>Current Time: {app.current_time.time().isoformat()}</p><br/>
<p>Estimated arrival Time: {arrival_time.time().isoformat()}</p><br/>
<p>A bus is scheduled to stop outside the terminal shortly after your arrival.</p>
""")
    return Response(f"""
<p>Current Time: {app.current_time.time().isoformat()}</p><br/>
<p>Estimated arrival Time: {arrival_time.time().isoformat()}</p><br/>
<p>Nearby taxi services have been notified of the delay and should be on standby.</p>
""")


if __name__ == '__main__':
    app.run(host="0.0.0.0")
