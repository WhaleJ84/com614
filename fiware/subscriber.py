from flask import Flask, request, Response

app = Flask(__name__)
app.logger.setLevel("DEBUG")


@app.route("/subscription/ferry-delay", methods=["POST"])
def test():
    app.logger.info(request.json)
    return Response()


if __name__ == '__main__':
    app.run(host="0.0.0.0")
