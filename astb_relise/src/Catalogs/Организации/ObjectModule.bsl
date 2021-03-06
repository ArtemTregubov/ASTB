#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ИспользоватьГруппыИЛИ Тогда
		
		ОбновлениеИнформационнойБазыАсТБ.ЗаполнитьКоэффициентыПоставкиДляГруппИЛИПоУмолчанию();
		
	КонецЕсли;
	
	Если ИспользоватьПроцентИзноса Тогда
		
		Износ100 = Справочники.ПроцентыИзноса.НайтиПоКоду(100,,Ссылка);
		
		Если Износ100.Пустая() Тогда
			Износ100 = Справочники.ПроцентыИзноса.СоздатьЭлемент();
			Износ100.Код = 100;
			Износ100.Владелец = Ссылка;
			Износ100.Записать();
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли