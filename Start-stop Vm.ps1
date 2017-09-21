$cred=Get-Credential
$Subscription_List=Get-AzureRmSubscription
$scriptblock = {
param($Arg0, $Arg1, $Arg2, $Arg3)

Login-AzureRmAccount -Credential $Arg3

Select-AzureRmSubscription -SubscriptionName $Arg2

Stop-AzureRmVM -Name $Arg0 -ResourceGroupName $Arg1 -Force

}
foreach($subscription in $Subscription_List)
 {
   Write-Output " `n Subscription:" $subscription.SubscriptionName 
   Select-AzureRmSubscription -SubscriptionName $subscription.SubscriptionName
   $RG_List=Get-AzureRmResourceGroup
   foreach($RG in $RG_List)
    {
       $VM=Get-AzureRmVM -Status -ResourceGroupName $RG.ResourceGroupName -WarningAction silentlyContinue
       if($VM.Name)
       {
          #Write-Output "ResourceGroup:" $RG.ResourceGroupName  Green
          foreach ($VM_N in $VM)
          {
            if($VM_N.PowerState -eq 'VM running')
             {
               Write-Output "`n Resource Group:" $RG.ResourceGroupName   "VM Name:"  $vm_N.name     "VM Status:"  $vm_N.PowerState  
               Start-Job -ScriptBlock $scriptblock -Name StopMachine -ArgumentList $VM_N.Name, $RG.ResourceGroupName, $subscription.subscriptionName, $cred
               
             }   
          }
       }
    }
  } 
 
 while(Get-Job -State Running)
  {
    start-sleep -Seconds 60
    $gj=Get-Job -State Running
    Write-Output "Waiting for all VM's to Stop"
    Write-Output $gj 
  }

