#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ЗначениеИзменено;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеИзменено = Значение <> Константы.ИспользоватьДополнительныеРеквизитыИСведения.Получить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеИзменено Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
			МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
			МодульУправлениеДоступом.ОбновитьРазрешенныеЗначенияПриИзмененииИспользованияВидовДоступа();
		КонецЕсли;
		
		Если Значение = Ложь Тогда
			Константы.ИспользоватьОбщиеДополнительныеЗначения.Установить(Ложь);
			Константы.ИспользоватьОбщиеДополнительныеРеквизитыИСведения.Установить(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
