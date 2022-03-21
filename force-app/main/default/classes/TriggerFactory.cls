/*********************************************************************************
*                                    Itaú - 2019
*
* Classe responsavel por realizar o factory de trigger
* Empresa: everis do Brasil
* Autor: Rafael Amaral Moreira
*
********************************************************************************/
public class TriggerFactory
{
    public class TriggerFactoryException extends Exception{}

    public static void createHandler(Schema.sObjectType aSOType)
    {
        if(!Trigger.isExecuting) { return; }

        ITrigger lHandler = getHandler(aSOType);
        if(lHandler == null) { return; }

        execute(lHandler);
    }

    private static void execute(ITrigger aHandler)
    {
        if (Trigger.isBefore)
        {
            aHandler.bulkBefore();

            if(Trigger.isInsert) { aHandler.beforeInsert(); }
            else if(Trigger.isUpdate) { aHandler.beforeUpdate(); }
            else if(Trigger.isDelete) { aHandler.beforeDelete(); }
        }
        else
        {
            aHandler.bulkAfter();

            if(Trigger.isInsert) { aHandler.afterInsert(); }
            else if (Trigger.isUpdate) { aHandler.afterUpdate(); }
            else if (Trigger.isDelete) { aHandler.afterDelete(); }
        }
        aHandler.andFinally();
    }

    /**
    * @description Create instance of a class handler dynamically, to work the Handler class must have the name of the object + TriggerHandler.
    * Examples:
         * CaseTriggerHandler
         * MyCustomizedObjectTriggerHandler
    * @param aSOType
    * @return Instance of class that implements ITrigger interface
    */
    private static ITrigger getHandler(Schema.sObjectType aSOType)
    {
        String lClassName = String.valueOf(aSOType).remove('__c') + 'TriggerHandler';

        try
        {
            Type lType = Type.forName(lClassName);
            if (lType == null)
            {
                throw new TriggerFactoryException('Class TriggerHandler named ' + lClassName + ' not found');
            }
            ITrigger lHandler = (ITrigger) lType.newInstance();
            return lHandler;
        }
        catch(Exception lException)
        {
            throw lException;
        }
    }
}