#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)
	
	// Вызывается непосредственно до записи объекта в базу данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТиповыеОтраслевыеНормы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ТиповыеОтраслевыеНормы КАК ТиповыеОтраслевыеНормы
	|ГДЕ
	|	ТиповыеОтраслевыеНормы.Наименование = &Наименование
	|	И НЕ ТиповыеОтраслевыеНормы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Наименование",	Наименование);
	Запрос.УстановитьПараметр("Ссылка", 		Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "ТОН с таким наименованием уже существует.";
		СообщениеПользователю.Сообщить();
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры	
	
#КонецЕсли