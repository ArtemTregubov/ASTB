
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Справочник.Организации.ФормаОбъекта", ПолучитьПараметрыОткрытиФормы());
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыОткрытиФормы()
	
	Возврат Новый Структура("Ключ", Справочники.Организации.ОрганизацияПоУмолчанию());
	
КонецФункции
