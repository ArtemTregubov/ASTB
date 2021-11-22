&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДокументаНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Документы.УстановкаПериодаЗимы.ЗаполнитьТабличнуюЧасть(Объект);
	// Мадатов Ю.А. --#124560 "Установка периодов зимы"-- (21.10.21)<<<
	ЗаполнениеПериодыЗимы();
	// Мадатов Ю.А. --#124560 "Установка периодов зимы"-- (21.10.21)>>>
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.ПериодыЗимы.Количество() > 0 Тогда

		Текст = "ru = ""Табличная часть будет очищена! Продолжить выполнение операции?"";";
		
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Параметры);
		
		ПоказатьВопрос(Оповещение,НСтр(Текст),РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ЗаполнитьТаблицуДокументаНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;

    Объект.ПериодыЗимы.Очистить();

	ЗаполнитьТаблицуДокументаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	ИзменитьФлажкиНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	ИзменитьФлажкиНаСервере(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьФлажкиНаСервере(ЗначениеФлажка)
	
	Документ = РеквизитФормыВЗначение("Объект");
	
	ТаблицаДокумента = Документ.ПериодыЗимы.Выгрузить();
	ТаблицаДокумента.ЗаполнитьЗначения(ЗначениеФлажка, "Использовать");
	Документ.ПериодыЗимы.Загрузить(ТаблицаДокумента);
	
	ЗначениеВРеквизитФормы(Документ,"Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
КонецПроцедуры

// Мадатов Ю.А. --#124560 "Установка периодов зимы"-- (21.10.21)<<<
&НаКлиенте
Процедура УстановитьДляВсехПриИзменении(Элемент)
	
	Элементы.НачалоЗимы.ТолькоПросмотр	 = Не УстановитьДляВсех;
	Элементы.КонецЗимы.ТолькоПросмотр	 = Не УстановитьДляВсех;
	
КонецПроцедуры

Процедура ЗаполнениеПериодыЗимы()

	Если УстановитьДляВсех И  ЗначениеЗаполнено(НачалоЗимы) И ЗначениеЗаполнено(КонецЗимы) Тогда
		ВыбранныйПериодЗимы = Новый Структура("НачалоЗимы, КонецЗимы", НачалоЗимы, КонецЗимы);
		
		Для Каждого СтрокаПериодыЗимы Из Объект.ПериодыЗимы Цикл
			ЗаполнитьЗначенияСвойств(СтрокаПериодыЗимы, ВыбранныйПериодЗимы);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоЗимыПриИзменении(Элемент)
	ЗаполнениеПериодыЗимы();
КонецПроцедуры

&НаКлиенте
Процедура КонецЗимыПриИзменении(Элемент)
	ЗаполнениеПериодыЗимы();
КонецПроцедуры
// Мадатов Ю.А. --#124560 "Установка периодов зимы"-- (21.10.21)>>>
