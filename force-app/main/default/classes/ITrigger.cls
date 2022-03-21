/*********************************************************************************
*                                    Itaú - 2019
*
* Classe responsavel por realizar ser a interface factory de trigger
* Empresa: everis do Brasil
* Autor: Rafael Amaral Moreira
*
********************************************************************************/
public interface  ITrigger
{
  void bulkBefore();
  void bulkAfter();
  void beforeInsert();
  void beforeUpdate();
  void beforeDelete();
  void afterInsert();
  void afterUpdate();
  void afterDelete();
  void andFinally();
}