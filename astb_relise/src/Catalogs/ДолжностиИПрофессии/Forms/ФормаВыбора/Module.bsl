&НаКлиенте
Процедура ПодборПоКлассификатору(Команда)
	
	ОткрытьФормуМодально("Справочник.ДолжностиИПрофессии.Форма.ОКПДТР");
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.СписокПрофессий) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭтаФорма.Список.Отбор, "Ссылка", Параметры.СписокПрофессий,ВидСравненияКомпоновкиДанных.ВСписке, "Ссылка", Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭтаФорма.Список.Отбор, "Ссылка", Параметры.СписокПрофессий,ВидСравненияКомпоновкиДанных.ВСписке, "Ссылка", Ложь);
	КонецЕсли;
	
КонецПроцедуры
