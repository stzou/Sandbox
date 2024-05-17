curl -X POST "https://http-intake.logs.datadoghq.com/api/v2/logs" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: <MY_API_KEY>" \
-d @- << EOF
[
    {
        "ddsource": "test",
        "level": "info",
        "properties": {
            "healthErrors": [
                {
                    "possibleCauses": "There is a sudden spike (peak) in the churn rate for the below disks due to which high amount of data is pending for upload.\n1. RFABKQ9SQLA01P-datadisk-02, Data pending for upload due to churn higher than the supported limits : 1GB, ObservationTime : Wed Nov  1 16:49:33 2023 UTC, PeakChurn(MBps) : 146MB\n    ",
                    "creationTime": "2023-11-01T17:07:15.2294624Z",
                    "errorMessage": "Sudden spike in data change rate (churn) is observed on replicating disk(s) 'RFABKQ9SQLA01P-datadisk-02'.",
                    "recommendation": "Review the Azure Site Recovery supported limits at https://aka.ms/asr-a2a-target-limits. Ensure that the target storage type (Standard or Premium) is provisioned as per the churn rate at source.",
                    "errorCode": 153055,
                    "version": "2016-12-05"
                },
                {
                    "possibleCauses": "There is a sudden spike (peak) in the churn rate for the below disks due to which high amount of data is pending for upload.\n1. RFABKQ9SQLA01P-datadisk-02, Data pending for upload due to churn higher than the supported limits : 1GB, ObservationTime : Wed Nov  1 16:49:33 2023 UTC, PeakChurn(MBps) : 146MB\n    ",
                    "creationTime": "2023-11-01T17:07:15.2294624Z",
                    "errorMessage": "22",
                    "recommendation": "Review the Azure Site Recovery supported limits at https://aka.ms/asr-a2a-target-limits. Ensure that the target storage type (Standard or Premium) is provisioned as per the churn rate at source.",
                    "errorCode": 153055,
                    "version": "2016-12-05"
                }
            ],
            "version": "2016-12-05"
        }
    }
]
EOF
