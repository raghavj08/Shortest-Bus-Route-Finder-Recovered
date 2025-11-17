import requests
import json
import uuid
import time

GRAPHQL_API_URL = "https://r4kge5xew5hujalr42pqqc2u2u.appsync-api.eu-north-1.amazonaws.com/graphql"
API_KEY = "da2-equehr67andpve34uuv57jv3vm"

stops = [
    "New Maloya Colony", "Manimajra", "Mansa Devi", "ISBT-43", "Ram Darbar",
    "Raipur Kalan", "PGI", "Zirakpur", "IT Park", "Nada Sahib"
]

buses = {
    "Bus 1": [
        [0, 24, 30, -1, 38, 25, 15, -1, -1, -1],
        [24, 0, 10, 22, -1, -1, 12, -1, 18, 20],
        [30, 10, 0, 28, -1, -1, 20, -1, 25, 27],
        [-1, 22, 28, 0, 12, 17, 10, 20, 15, -1],
        [38, -1, -1, 12, 0, 15, -1, 10, -1, -1],
        [25, -1, -1, 17, 15, 0, 18, 20, 22, -1],
        [15, 12, 20, 10, -1, 18, 0, -1, 8, 10],
        [-1, -1, -1, 20, 10, 20, -1, 0, -1, 15],
        [-1, 18, 25, 15, -1, 22, 8, -1, 0, 10],
        [-1, 20, 27, -1, -1, -1, 10, 15, 10, 0]
    ],
    "Bus 2": [
        [0, 20, -1, 35, -1, 28, 14, -1, -1, -1],
        [20, 0, 12, 25, -1, -1, 10, -1, 19, 22],
        [-1, 12, 0, 30, -1, -1, 18, -1, 23, 26],
        [35, 25, 30, 0, 15, 20, 12, 22, 17, -1],
        [-1, -1, -1, 15, 0, 18, -1, 12, -1, -1],
        [28, -1, -1, 20, 18, 0, 16, 22, 24, -1],
        [14, 10, 18, 12, -1, 16, 0, -1, 9, 12],
        [-1, -1, -1, 22, 12, 22, -1, 0, -1, 18],
        [-1, 19, 23, 17, -1, 24, 9, -1, 0, 11],
        [-1, 22, 26, -1, -1, -1, 12, 18, 11, 0]
    ]
}

CREATE_MUTATION = """
mutation CreateBusRoute($input: CreateBusRouteInput!) {
  createBusRoute(input: $input) {
    id
    from
    to
    distance
    roadway
    stops
  }
}
"""

HEADERS = {
    "Content-Type": "application/json",
    "x-api-key": API_KEY
}

def call_graphql(mutation, variables):
    response = requests.post(
        GRAPHQL_API_URL,
        headers=HEADERS,
        json={"query": mutation, "variables": variables}
    )
    if response.status_code != 200:
        print("GraphQL HTTP Error:", response.status_code, response.text)
        return None

    data = response.json()
    if "errors" in data:
        print("GraphQL Errors:", data["errors"])
        return None

    return data["data"]

def push_routes():
    print("=== Starting Upload ===")
    total = 0

    for bus_name, graph in buses.items():
        for i in range(len(stops)):
            for j in range(len(stops)):
                if graph[i][j] != -1 and i != j:
                    item = {
                        "from": stops[i],
                        "to": stops[j],
                        "distance": graph[i][j],
                        "roadway": bus_name,
                        "stops": [stops[i], stops[j]]
                    }

                    variables = {"input": item}
                    result = call_graphql(CREATE_MUTATION, variables)

                    if result:
                        print(f"Uploaded: {item}")
                    else:
                        print(f"Failed: {item}")

                    total += 1
                    time.sleep(0.1)

    print(f"=== Done. Total routes pushed: {total} ===")

if __name__ == "__main__":
    push_routes()
