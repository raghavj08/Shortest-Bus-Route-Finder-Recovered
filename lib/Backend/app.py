from flask import Flask, request, jsonify
import sys

app = Flask(__name__)

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

def floyd_warshall(graph, n):
    dist = [[sys.maxsize] * n for _ in range(n)]
    next_stop = [[-1] * n for _ in range(n)]

    for i in range(n):
        for j in range(n):
            if i == j:
                dist[i][j] = 0
            elif graph[i][j] != -1:
                dist[i][j] = graph[i][j]
                next_stop[i][j] = j

    for k in range(n):
        for i in range(n):
            for j in range(n):
                if dist[i][k] != sys.maxsize and dist[k][j] != sys.maxsize:
                    if dist[i][k] + dist[k][j] < dist[i][j]:
                        dist[i][j] = dist[i][k] + dist[k][j]
                        next_stop[i][j] = next_stop[i][k]
    return dist, next_stop


def reconstruct_route(next_stop, start, end):
    if next_stop[start][end] == -1:
        return []
    path = [start]
    while start != end:
        start = next_stop[start][end]
        path.append(start)
    return [stops[i] for i in path]

def get_stop_index(stop_name):
    stop_name = stop_name.strip().lower() 
    for i, stop in enumerate(stops):
        if stop.strip().lower() == stop_name:  
            return i
    return -1


@app.route('/shortest-path', methods=['GET'])
def shortest_path():
    source = request.args.get('source')
    destination = request.args.get('destination')

    if not source or not destination:
        return jsonify({"error": "Please provide both source and destination"}), 400

    start_idx = get_stop_index(source)
    end_idx = get_stop_index(destination)

    if start_idx == -1 or end_idx == -1:
        return jsonify({"error": "Invalid stop name. Please check available stops."}), 404

    best_bus = None
    shortest_distance = sys.maxsize
    best_route = []

    results = []

    for bus, graph in buses.items():
        dist, next_stop = floyd_warshall(graph, len(stops))
        distance = dist[start_idx][end_idx]
        route = reconstruct_route(next_stop, start_idx, end_idx)

        if distance != sys.maxsize:
            results.append({
                "bus": bus,
                "distance": distance,
                "route": route
            })

            if distance < shortest_distance:
                shortest_distance = distance
                best_bus = bus
                best_route = route

    if not best_bus:
        return jsonify({"error": f"No available bus between {source} and {destination}."}), 404

    return jsonify({
        "source": source,
        "destination": destination,
        "best_bus": best_bus,
        "best_route": best_route,
        "total_distance_km": shortest_distance,
        "all_available_routes": results
    })

@app.route('/available-stops', methods=['GET'])
def available_stops():
    return jsonify({"available_stops": stops})



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000,debug=True)