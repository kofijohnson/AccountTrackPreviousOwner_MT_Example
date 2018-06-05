/**
* @description Criteria Object on TriggerBeforeUpdate that will be used in a
* Before Update context to find Accounts whose OwnerIds changed.
*/
public class AccountOwnerChangedCriteria implements TriggerBeforeUpdate.Criteria {

    /*******************************************************************************************************
    * @description The single method in the Criteria Interface to implement.
    * Return a list of records which match the desired criteria, given the Trigger Context object.
    * @param TriggerBeforeUpdate.Context The Before Update Trigger Context.
    * @return List<SObject> The list of the records which match the criteria. In this case, the list of 
    * accounts whose Owner have changed.
    ********************************************************************************************************/
    public List<SObject> run(TriggerBeforeUpdate.Context currentContext) {
        List<Account> accounts = new List<Account>();
 
        // Iterate through all changed records, and add accounts
        // whose ownerid's have just changed to the result list
        for(Account newAccount : (List<Account>) currentContext.newList) {
            Account oldAccount = (Account) currentContext.oldMap.get(newAccount.Id);
            if(newAccount.OwnerId != oldAccount.OwnerId) {
                accounts.add(newAccount);
            }
        }
        // return the list of records which have fulfilled the criteria.
        return accounts;
    }
}