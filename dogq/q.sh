#!/bin/bash
######################################################################################################
## Purpose: Open a bash session on a running cloud pod for Delancie crawler investigations
## Input:   User selects Datadog Instance and Cloud Provider
## Author:  Mandy Kopelke (updated by Ava Silver)
######################################################################################################

## Install dependency if missing:
command -v gum 2>&1 > /dev/null || (echo 'Installing `gum`, this will only happen once...'; brew install gum)

exit_script() {
    gum style --bold --foreground 1 "Exiting..."
    exit
}

gum style --border double --margin "1" --padding "1 1" --border-foreground 2 \
"Hi there! This is the cloud bash script.
Use Ctrl+C or press ESC in any chooser to exit early."
##
## Select US or EU Instance
##
DD_INSTANCE=`gum choose \
    --header="Select Datadog Instance:"\
    US1 EU US3 US5 AP1 GOV STAGING "<EXIT>"`

case $DD_INSTANCE in
    US1)        ddtool clusters use psyduck.us1.prod.dog;;
    EU)         ddtool clusters use babar.eu1.prod.dog;;
    US3)        ddtool clusters use torkoal.us3.prod.dog;;
    US5)        ddtool clusters use nidoking.us5.prod.dog;;
    AP1)        ddtool clusters use whiscash.ap1.prod.dog;;
    GOV)        ddtool clusters use plain1.us1.fed.dog;;
    STAGING)    ddtool clusters use stripe.us1.staging.dog;;
    *)          exit_script;;
esac

##
## Select Cloud provider
##
DD_CLOUD=`gum choose \
    --header="Select Cloud Platform:"\
    AWS Azure GCP "<EXIT>"`
case $DD_CLOUD in
    AWS)
        kubens aws-integrations
        ;;
    Azure)
        SERVICE="azure-workers"
        kubens azure-integrations
        ;;
    GCP)
        SERVICE="delancie-crawler-gcp"
        ## This is for the go service but I don't know what that is for exactly
        ##SERVICE="gcp-crawler"
        kubens delancie
        ## still delancie but eventually gcp-integrations
        ##kubens gcp-integrations
        ;;
    *)  exit_script;;
esac

##
## Get name of the first running pod in the list returned by "kubectl get po" based on selected Cloud provider: $SERVICE
## Based on the best practices, it seems like two different flavors are generally used for AWS and Azure (GCP pending)
##

case $DD_CLOUD in
    AWS)
        AWS_FLAVOR=`gum choose --header="Select AWS FLAVOR Type:" Resource Metric "<EXIT>"`
        case $AWS_FLAVOR in
            Resource)  SERVICE="aws-resources-workers";;
            Metric)    SERVICE="aws-metrics-workers";;
            *)         exit_script;;
        esac
        export PODNAME1=`kubectl get po -l service=$SERVICE -o wide|grep Running|grep -v canary|awk 'NR==1{print $1}'`
        ;;
    Azure)
        AZURE_POD=`gum choose \
            --header="Select Azure Pod Type:"\
            Resource Metric "<EXIT>"`
        case $AZURE_POD in
            Resource)  POD="azure-meta";;
            Metric)    POD="azure-metrics";;
            *)         exit_script;;
        esac
        export PODNAME1=`kubectl get po -l service=$SERVICE -o wide|grep Running|grep -v canary|grep $POD|awk 'NR==1{print $1}'`
        ;;
    *)
        export PODNAME1=`kubectl get po -l service=$SERVICE,app=worker -o wide|grep Running|grep -v canary|awk 'NR==1{print $1}'`
        ;;
esac
##
## Open a bash session on a currently running pod for the selected cloud platform
##
gum style --border normal --margin "1" --padding "1 1" --border-foreground 32 \
"Opening bash in pod: $PODNAME1...
Using command:
kubectl exec -it $PODNAME1 -c delancie-worker -- bash"

kubectl exec -it $PODNAME1 -c delancie-worker -- bash
