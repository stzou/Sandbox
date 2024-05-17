curl -X POST "https://http-intake.logs.datadoghq.com/api/v2/logs" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: <MY_API_KEY>" \
-d @- << EOF
[
    {
        "date": "2023-10-04T19:20:00.720394912Z",
        "level": "info",
        "src": {
            "function": "gitlab.teracloud.ninja/teracloud/saas-services/applications/alert-management-service/app.dumpEnvironmentVariablesIfEnabled",
            "file": "/go/src/app/app/app.go",
            "line": 133
        },
        "msg": "dumpEnvironmentVariables",
        "ddsource": "curlTest",
        "value": false
    }
]
EOF
