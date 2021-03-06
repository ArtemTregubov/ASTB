#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если СокрЛП(Код) = "" Тогда
		УстановитьНовыйКод();
	КонецЕсли;
	
	НовыйПолныйАдрес = ПроцедурыРаботыСНормамиСервер.СлитьАдреса(ПроцедурыРаботыСНормамиСервер.ПолучитьПолныйАдресТочкиХранения(Родитель), Код);
	
	Если ПолныйАдрес <> НовыйПолныйАдрес Тогда
		ПолныйАдрес = НовыйПолныйАдрес;
		//Если ЭтоГруппа Тогда
		//	НеобходимоПерезаписатьПодчиненных = Истина;
		//КонецЕсли;
	КонецЕсли;
	
	// Наименование элемента справочника состоит из наименования вида, полного наименование и полного
	// кода справочника
	НовоеНаименование = СокрЛП(ВидТочкиХранения.Наименование) + " " + ПолныйАдрес;
	
	Если ДополнениеКНаименованию <> "" Тогда
		// Добавим к наименованию полное наименование в скобках
		НовоеНаименование = НовоеНаименование + " (" + СокрЛП(ДополнениеКНаименованию) + ")";
	КонецЕсли;
	
	Если Наименование <> НовоеНаименование Тогда
		Наименование = НовоеНаименование;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

