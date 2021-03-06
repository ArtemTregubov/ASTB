&НаСервере
Процедура ПроверитьПодключениеНаСервере()
	
	ПолучитьПроксиНаСервере();	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	ПроверитьПодключениеНаСервере();	
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПроксиНаСервере()
	
	ОписаниеОшибки = "";
	
	Прокси = РегистрыСведений.ПараметрыПодключенияКСервисуДляЗагрузкиГТД.ПолучитьПрокси(ОписаниеОшибки,Запись.Адрес,Запись.URI,Запись.Пользователь,Запись.Пароль);
	
	Если Прокси = Неопределено Тогда
		ОписаниеОшибки = "Ошибка подключения." + Символы.ПС + ОписаниеОшибки;
	Иначе
		ОписаниеОшибки = "Подключение установлено.";
	КонецЕсли;
	
	СообщениеПользователю = Новый СообщениеПользователю;
	СообщениеПользователю.Текст = ОписаниеОшибки;
	СообщениеПользователю.Сообщить();
	
КонецПроцедуры


