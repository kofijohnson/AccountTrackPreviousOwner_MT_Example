/**
* @description Action Object on TriggerBeforeUpdate that will be used in a
* Before Update context to update the description field of the  Accounts 
* whose OwnerIds changed.
*/
public class AccountTrackPreviousOwnerAction implements TriggerBeforeUpdate.Action {

    /*******************************************************************************************************
    * @description The single method in the Action Interface to implement.
    * @param TriggerBeforeUpdate.Context. The Before Update Trigger Context.
    * @param List<SObject>. List<SObject> The list of the records which match the criteria. 
    * In this case, the list of accounts whose Owner have changed.
    * @return Boolean. A flag that tells if the Action runs successfull or not.
    ********************************************************************************************************/
    public Boolean run(TriggerBeforeUpdate.Context currentContext, List<SObject> scope) {
        // Get the accounts owners.
        Set<Id> userIds = new Set<Id>();
        for (Account newAccount : (List<Account>) scope) {
            Account oldAccount = (Account) currentContext.oldMap.get(newAccount.Id);
            userIds.add(oldAccount.OwnerId);
        }
        Map<Id,User> accountsOwners = new Map<Id,User>([
            SELECT Id, FirstName, LastName 
            FROM User WHERE Id IN :userIds
        ]);
        
        // Track the previous owner on the account's description.
        for(Account newAccount : (List<Account>) scope) {
            Account oldAccount = (Account) currentContext.oldMap.get(newAccount.Id);
            User oldOwner = accountsOwners.get(oldAccount.OwnerId);
            newAccount.Description = 'Previous Owner: ' + oldOwner.FirstName + ' ' + oldOwner.LastName;
        }

        // Return true to tell the Framework that the logic runs successfully.
        return true;
    }
}