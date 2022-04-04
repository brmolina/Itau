/**
 * Created by vbernara on 2020-04-28.
 */
@isTest
public with sharing class EX3_AdvogadoTriggerHandlerTest {

	@testSetup static void setup(){

		Account lAccount = new Account(
			RecordTypeId = EX3_Utils.getRecordTypeIdByDevName('Account', 'EX3_Envolvido'),
			Name = 'Conta Test'
			);
		Database.insert(lAccount);

		Contact lContact = new Contact(
			RecordTypeId = EX3_Utils.getRecordTypeIdByDevName('Contact', 'EX3_Advogado'),
			AccountId = lAccount.Id,
			FirstName = 'Contato',
			LastName = 'Test'
			);
		Database.insert(lContact);

		EX3_Advogado__c lAdvogado = new EX3_Advogado__c(
            RecordTypeId = EX3_Utils.getRecordTypeIdByDevName('EX3_Advogado__c', 'EX3_Advogado_interno'),
            Name = lContact.FirstName + ' ' + lContact.LastName,
            EX3_Advogado__c = lContact.Id
        );
		Database.insert(lAdvogado);
	}

	@isTest
	static void updateAdvogado(){
        
        EX3_Advogado__c lAdvogado = [SELECT Id, Name FROM EX3_Advogado__c WHERE Name = 'Contato Test'];

		Test.startTest();
		lAdvogado.Name = 'Advogado Test Update';
		update lAdvogado;
		Test.stopTest();

		EX3_Advogado__c lAdvogadoUpdate  = [SELECT Id, Name FROM EX3_Advogado__c WHERE Id = :lAdvogado.Id];
		System.assertEquals('Advogado Test Update', lAdvogadoUpdate.Name);
	}

	@isTest
	static void deleteAdvogado(){
        
        EX3_Advogado__c lAdvogado = [SELECT Id, Name FROM EX3_Advogado__c WHERE Name = 'Contato Test'];

		Test.startTest();
		delete lAdvogado;
		Test.stopTest();

		EX3_Advogado__c lAdvogadoUpdate = [SELECT Id, Name, IsDeleted FROM EX3_Advogado__c WHERE Id = :lAdvogado.Id ALL ROWS];
		System.assertEquals(lAdvogadoUpdate.IsDeleted, true);
	}
}