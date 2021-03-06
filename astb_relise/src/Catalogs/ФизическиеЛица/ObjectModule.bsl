#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)
	
	// Вызывается непосредственно до записи объекта в базу данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Наименование = &Наименование
	|	И ФизическиеЛица.КодСинхронизации = &КодСинхронизации
	|	И НЕ ФизическиеЛица.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Наименование", 		Наименование);
	Запрос.УстановитьПараметр("КодСинхронизации", 	КодСинхронизации);
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Физическое лицо с такими ФИО и кодом синхронизации уже существует.";
		СообщениеПользователю.Сообщить();
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры	
	
#КонецЕсли