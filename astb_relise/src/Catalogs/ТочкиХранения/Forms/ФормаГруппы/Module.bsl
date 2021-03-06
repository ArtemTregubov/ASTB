
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Склад.Видимость = (Объект.ВидТочкиХранения = Справочники.ВидыТочекХранения.Склад);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ВидТочкиХранения = ПредопределенноеЗначение("Справочник.ВидыТочекХранения.Склад") Тогда
		Если ЗначениеЗаполнено(Объект.Склад) Тогда
			Отказ = СкладИспользуется();
		Иначе
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Не заполнен склад!";
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция СкладИспользуется()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТочкиХранения.Ссылка КАК ТочкаХранения
	|ИЗ
	|	Справочник.ТочкиХранения КАК ТочкиХранения
	|ГДЕ
	|	НЕ ТочкиХранения.Ссылка = &Ссылка
	|	И ТочкиХранения.Склад = &Склад";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Склад", 	Объект.Склад);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		ТаблицаЗапроса = Результат.Выгрузить();
		ТочкаХранения = ТаблицаЗапроса[0].ТочкаХранения.Наименование;
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Выбранный склад уже привязан к точке хранения: " + ТочкаХранения;
		СообщениеПользователю.Сообщить();
		Возврат Истина;	
	КонецЕсли;	
	
КонецФункции	

&НаСервере
Процедура ВидТочкиХраненияПриИзмененииНаСервере()
	
	НовыйПолныйАдрес = ПроцедурыРаботыСНормамиСервер.СлитьАдреса(ПроцедурыРаботыСНормамиСервер.ПолучитьПолныйАдресТочкиХранения(Объект.Родитель), Объект.Код);
	
	НовоеНаименование = СокрЛП(Объект.ВидТочкиХранения.Наименование) + " " + НовыйПолныйАдрес;
	
	Если Объект.ДополнениеКНаименованию <> "" Тогда
		// Добавим к наименованию полное наименование в скобках
		НовоеНаименование = НовоеНаименование + " (" + СокрЛП(Объект.ДополнениеКНаименованию) + ")";
	КонецЕсли;
	
	Если Объект.Наименование <> НовоеНаименование Тогда
		Объект.Наименование = НовоеНаименование;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	Элементы.Склад.Видимость = (Объект.ВидТочкиХранения = Справочники.ВидыТочекХранения.Склад);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидТочкиХраненияПриИзменении(Элемент)
	
	ВидТочкиХраненияПриИзмененииНаСервере();
	
КонецПроцедуры
