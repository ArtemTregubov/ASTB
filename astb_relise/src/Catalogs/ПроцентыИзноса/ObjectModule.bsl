#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)
	
	// Вызывается непосредственно до записи объекта в базу данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Код > 100 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Износ не может превышать 100%";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроцентыИзноса.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПроцентыИзноса КАК ПроцентыИзноса
	|ГДЕ
	|	ПроцентыИзноса.Владелец = &Владелец
	|	И ПроцентыИзноса.Код = &Код
	|	И НЕ ПроцентыИзноса.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Владелец", 	Владелец);
	Запрос.УстановитьПараметр("Код", 		Код);
	Запрос.УстановитьПараметр("Ссылка", 	Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Процент износа с таким значением уже существует.";
		СообщениеПользователю.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли