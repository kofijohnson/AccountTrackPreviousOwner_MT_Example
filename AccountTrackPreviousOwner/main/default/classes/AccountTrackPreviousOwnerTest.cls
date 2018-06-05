/**
* @description Test class of the Action MicroTrigger Action "AccountTrackPreviousOwner".
*/
@isTest
private class AccountTrackPreviousOwnerTest {
    private static final String PREVIOUS_ACCOUNT_OWNER = 'previous_accountOwner@testing.com';
    private static final String NEW_ACCOUNT_OWNER = 'new_accountOwner@testing.com';

    /**************************************************************************************************************************
    @description Creates the 2 users needed for this test. 
    @return void.
    ***************************************************************************************************************************/
    @TestSetup private static void createTestData() {
        Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        insert new List<User>{
            new User(
                FirstName = 'USER_1',
                LastName = 'TEST',
                Email = PREVIOUS_ACCOUNT_OWNER,
                Username = PREVIOUS_ACCOUNT_OWNER + System.currentTimeMillis(),
                Alias = 'user1',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = systemAdminProfile.Id
            ),
            new User(
                FirstName = 'USER_2',
                LastName = 'TEST',
                Email = NEW_ACCOUNT_OWNER,
                Username = NEW_ACCOUNT_OWNER + System.currentTimeMillis(),
                CompanyName = 'TEST_COMPANY',
                Alias = 'user2',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = systemAdminProfile.Id
            )
        };
    }

    /**************************************************************************************************************************
    @description Given an Account, When the Account Owner is updated, Then the Account Description equals
    * 'Previous Owner: OLD_OWNER_FIRSTNAME OLD_OWNER_LASTNAME'.
    ***************************************************************************************************************************/
    @isTest static void test_TrackPreviousOwner_When_AccountOwnerChanged() {
        User previousAccountOwner, newAccountOwner;
        for (User currentUser : [SELECT FirstName, LastName, Email FROM User]) {
            if (currentUser.Email == PREVIOUS_ACCOUNT_OWNER) {
                previousAccountOwner = currentUser;
            }
            if (currentUser.Email == NEW_ACCOUNT_OWNER) {
                newAccountOwner = currentUser;
            }
        }

        System.runAs(previousAccountOwner) {
            Account account = new Account(
                Name = 'TEST_ACCOUNT'
            );
            insert account;

            Test.startTest();
            account.OwnerId = newAccountOwner.Id;
            update account;
            Test.stopTest();

            Account updatedAccount = [SELECT Description FROM Account WHERE Id = :account.Id];
            System.assertEquals(
                'Previous Owner: ' + previousAccountOwner.FirstName + ' ' + previousAccountOwner.LastName,
                updatedAccount.Description
            );
        }
    }

    /**************************************************************************************************************************
    @description Unit Test. In this test, all the real MicroTriggers in the org are removed, and only The AccountOwnerChanged
    * MicroTrigger (created dynamically) is registered. The goal is to test only the AccountOwnerChanged MicroTrigger and 
    * its related Action AccountTrackPreviousOwnerAction.
    ***************************************************************************************************************************/
    @isTest static void unitTest_TrackPreviousOwner_When_AccountOwnerChanged() {
        // Create a Mock of the AccountOwnerChanged MicroTrigger and configure it by adding the Criteria class and the Action class to run.
        TriggerBeforeUpdate.MicroTrigger accountOwnerChangedMock = new TriggerBeforeUpdate.MicroTrigger('AccountOwnerChangedMock', 'Account');
        accountOwnerChangedMock.setCriteria('AccountOwnerChangedCriteria')
                    .addAction('AccountTrackPreviousOwnerAction')
                    .activate();

        // Then override the current list of the default (real) MicroTriggers in the org with the AccountOwnerChanged MicroTrigger Mock.
        // This will force the framework to use only the AccountOwnerChanged MicroTrigger.
        MicroTriggersLoader.getInstance().overrideMicroTriggers(new List<BaseMicroTrigger>{accountOwnerChangedMock});

        // Run the test.
        test_TrackPreviousOwner_When_AccountOwnerChanged();
    }
}