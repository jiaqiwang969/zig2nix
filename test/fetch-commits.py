import requests
import json
from datetime import datetime

def fetch_commits_by_date():
    # GitHub API URL
    api_url = "https://api.github.com/repos/ziglang/zig/commits"
    commits_data = {}

    # 可以设置时间范围
    params = {
        "since": "2021-01-01T00:00:00Z",
        "until": "2023-12-31T23:59:59Z",
        "per_page": 100  # 每页数量
    }

    response = requests.get(api_url, params=params)
    commits = response.json()

    for commit in commits:
        date = commit['commit']['author']['date'][:10]  # 获取 YYYY-MM-DD
        sha = commit['sha']
        message = commit['commit']['message'].split('\n')[0]  # 获取第一行作为描述

        commits_data[date] = {
            "commit": sha,
            "description": message
        }

    # 保存到文件
    with open('date-commits.json', 'w') as f:
        json.dump(commits_data, f, indent=2)

if __name__ == "__main__":
    fetch_commits_by_date()
