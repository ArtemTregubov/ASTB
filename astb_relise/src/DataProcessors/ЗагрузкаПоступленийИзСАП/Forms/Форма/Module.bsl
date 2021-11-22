&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодЛога.ДатаНачала = НачалоМесяца(ТекущаяДата());
	ПериодЛога.ДатаОкончания = КонецМесяца(ТекущаяДата());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусыДокументов(Команда)
	УстановитьСтатусыДокументовНаСервере();
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусыДокументовНаСервере()
	РезультатУстановкиСтатусов = Интеграция_САП_Сервер.УстановитьСтатусыДляОбработанныхДокументов(Объект.Организация, РезультатСозданияДокументовФорма.Выгрузить());
	Для Каждого Строка Из РезультатУстановкиСтатусов Цикл
		НоваяСтрокаРезультат = РезультатУстановкиСтатусовФорма.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаРезультат, Строка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОпроситьОчередьСАП(Команда)
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Для получения ответа необходимо выбрать организацию");
	Иначе	
		ОпроситьОчередьНаСервере();
	КонецЕсли;
КонецПроцедуры

Процедура ВывестиРезультатОчереди(РезультатОчередиМассивом)
	ТаблицаРезультатаОпросОчереди.Очистить();
	
	Для Каждого Строка Из РезультатОчередиМассивом Цикл
		НоваяСтрокаРезультат = ТаблицаРезультатаОпросОчереди.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаРезультат, Строка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОпроситьОчередьНаСервере()  
	
	НастройкиПараметровОбмена = Интеграция_САП_Сервер.НастройкиПараметровОбменаСАП(Объект.Организация);	
	ТаблицаРезультатОпросаОчереди = Интеграция_САП_Сервер.РезультатОпросаОчередиСАП(Объект.Организация,НастройкиПараметровОбмена);
		
	ВывестиРезультатОчереди(ТаблицаРезультатОпросаОчереди);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДокументыПоОпросуОчереди()
	ТаблицаЗначенийОчереди = РеквизитФормыВЗначение("ТаблицаРезультатаОпросОчереди", Тип("ТаблицаЗначений"));
	ДанныеДокументовСтруктурой = Интеграция_САП_Сервер.ДокументыИзОпрошеннойОчереди(Объект.Организация, ТаблицаЗначенийОчереди);	
	РезультатСозданияДокументов = Интеграция_САП_Сервер.СформироватьДокументыПоступленияНоменклатурыИзДанныхСАП(ДанныеДокументовСтруктурой);
	ЕстьОшибка = Ложь;
	
	Для Каждого Результат Из  РезультатСозданияДокументов Цикл
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(?(ЗначениеЗаполнено(Результат.Ошибка),Строка(Результат.Документ)+": "+Символы.ПС+Результат.Ошибка, "Документ успешно создан успешно: "+Результат.Документ));
		ЕстьОшибка = ЗначениеЗаполнено(Результат.Ошибка);
		СтрокаРезультатаПоДокументам = РезультатСозданияДокументовФорма.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаРезультатаПоДокументам, Результат);
		Если ЗначениеЗаполнено(Результат.Ошибка) Тогда
			УровеньСообщения = ?(стрНайти(Результат.Ошибка, "Ошибка"), УровеньЖурналаРегистрации.Ошибка, УровеньЖурналаРегистрации.Предупреждение);
			РезультатДокумнт = ?(УровеньСообщения = УровеньЖурналаРегистрации.Ошибка, "Документ не создан из за ошибки", "Создан документ с предупреждением");
			ЗаписьЖурналаРегистрации("Загрузка SAP", УровеньСообщения,,,
			СтрШаблон(РезультатДокумнт+" 
			|Документ: %1,
			|Предупреждение: %2",
			Результат.Документ,
			Результат.Ошибка));
		Иначе
			ЗаписьЖурналаРегистрации("Загрузка SAP", УровеньЖурналаРегистрации.Информация,,,
			СтрШаблон("Создан документ успешно
			|Документ: %1",
			Результат.Документ));
			
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(?(ЕстьОшибка, "Задание выполнено с ошибками/предупреждениями. Все сообщения можно посмотреть в логе", "Задание выполнено успешно"));
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеПоДокументам(Команда)
	ЗагрузитьДокументыПоОпросуОчереди();
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьЛог(Команда)
	ПрочитатьЛогНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПрочитатьЛогНаСервере()
	
	МассивСобытий = Новый Массив;
	
	МассивСобытий.Добавить("Загрузка поступлений SAP. Начало обмена");
	МассивСобытий.Добавить("Загрузка поступлений SAP. Конец обмена");
	МассивСобытий.Добавить("Загрузка поступлений SAP. Опрос очереди");
	МассивСобытий.Добавить("Загрузка поступлений SAP. Создание документа");
	МассивСобытий.Добавить("Загрузка поступлений SAP. Ошибка обработки");
	МассивСобытий.Добавить("Загрузка поступлений SAP. Изменение статуса");
	
	СтруктураОтбора = Новый Структура("Событие",МассивСобытий);
	СтруктураОтбора.Вставить("ДатаНачала", ПериодЛога.ДатаНачала);
	СтруктураОтбора.Вставить("ДатаОкончания", ПериодЛога.ДатаОкончания);
	
	РезультатПоЖурналу  = Новый ТаблицаЗначений;
	
	ВыгрузитьЖурналРегистрации(РезультатПоЖурналу, СтруктураОтбора);
	
	Для Каждого СтрокаТаблицыИсточник из РезультатПоЖурналу Цикл 
		
		Если СтрокаТаблицыИсточник.Уровень = УровеньЖурналаРегистрации.Информация Тогда
			СтрокаТаблицыИсточник.Уровень = 0;
		ИначеЕсли СтрокаТаблицыИсточник.Уровень = УровеньЖурналаРегистрации.Предупреждение Тогда
			СтрокаТаблицыИсточник.Уровень = 1;
		ИначеЕсли СтрокаТаблицыИсточник.Уровень = УровеньЖурналаРегистрации.Ошибка Тогда
			СтрокаТаблицыИсточник.Уровень = 2;
		ИначеЕсли СтрокаТаблицыИсточник.Уровень = УровеньЖурналаРегистрации.Примечание Тогда
			СтрокаТаблицыИсточник.Уровень = 3;
		КонецЕсли;
		
	КонецЦикла;
	
	СобытияЖурналаРегистрации.Загрузить(РезультатПоЖурналу);
	СобытияЖурналаРегистрации.Сортировать("Дата Возр");

КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбменСАПНаСервере()
Интеграция_САП_Сервер.ЗагрузитьДокументыПоступленияНоменклатурыССАП();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменСАП(Команда)
	ВыполнитьОбменСАПНаСервере();
КонецПроцедуры

