$Subscription_List=Get-AzureRmSubscription
foreach($subscription in $Subscription_List)
 {
   Write-Host " `n Subscription:" $subscription.SubscriptionName -ForegroundColor DarkYellow
   Select-AzureRmSubscription -SubscriptionName $subscription.SubscriptionName
   $RG_List=Get-AzureRmResourceGroup
   foreach($RG in $RG_List)
    {
       $VM=Get-AzureRmVM -Status -ResourceGroupName $RG.ResourceGroupName -WarningAction silentlyContinue
       if($VM.Name)
       {
          foreach($VM_N in $VM)
          {
            if($VM_N.PowerState -eq 'VM deallocated')
             {
               Write-Host "`n Resource Group:" $RG.ResourceGroupName   "VM Name:"  $vm_N.name     "VM Status:"  $vm_N.PowerState -ForegroundColor Green
             }

            else
             {
               Write-Host "`n Resource Group:" $RG.ResourceGroupName   "VM Name:"  $vm_N.name     "VM Status:"  $vm_N.PowerState -ForegroundColor Red
             }
          }
       }
    }
 }   