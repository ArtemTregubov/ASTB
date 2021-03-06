#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
   	
	// Заполнение элементов формы согласно предыдущих настроек текущего пользователя.
	Результат = Интеграция1СБухфонВызовСервера.НастройкиУчетнойЗаписиПользователя();
	ВидимостьКнопки = Результат.ВидимостьКнопки1СБухфон;
	СохранитьЛогинПароль = Результат.ИспользоватьЛП;	
	Элементы.Логин.Доступность = Результат.ИспользоватьЛП;
	Элементы.Пароль.Доступность = Результат.ИспользоватьЛП;
	Логин = Результат.Логин;
	Пароль = Результат.Пароль;
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	ПутьКФайлу = Интеграция1СБухфонВызовСервера.РасположениеИсполняемогоФайла(ИдентификаторКлиента);
	
	ИнициализироватьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для работы с приложением необходима операционная система Microsoft Windows.'"));
		Отказ = Истина;		
	КонецЕсли;
	Если ПутьКФайлу="" Тогда
		ПутьКФайлу = Интеграция1СБухфонКлиент.ПутьКИсполняемомуФайлуИзРеестраWindows();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СохранитьЛогинПарольПриИзменении(Элемент)
	 
	Доступ = СохранитьЛогинПароль;
	Элементы.Логин.Доступность = Доступ;
	Элементы.Пароль.Доступность = Доступ;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьКнопкиПриИзменении(Элемент)
	ИнициализироватьЭлементыФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ПутьКФайлуНачалоВыбораЗавершение", ЭтотОбъект);
	Интеграция1СБухфонКлиент.ВыбратьФайл1СБухфон(Оповещение, ПутьКФайлу);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	ИдентификаторКлиента = Интеграция1СБухфонКлиент.ИдентификаторКлиента();	
	СохранитьНастройкиПользователяВХранилище(Логин, Пароль, СохранитьЛогинПароль, ВидимостьКнопки);
	НовыйПутьКИсполняемомуФайлу(ИдентификаторКлиента, ПутьКФайлу);
	// Оповестим форму кнопки для управления видимостью кнопки.
	Оповестить("СохранениеНастроек1СБухфон");
    ПриИзмененииНастроек();
	ОбновитьИнтерфейс();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьАккаунт1СБухфон(Команда)
	
	ПерейтиПоНавигационнойСсылке("http://buhphone.com/clients/be-client/");
	
КонецПроцедуры

&НаКлиенте
Процедура ТехническиеТребования(Команда)
	
	ПерейтиПоНавигационнойСсылке("http://buhphone.com/require/#anchor_1");
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьПриложение(Команда)
	
	ПерейтиПоНавигационнойСсылке("http://distribs.buhphone.com/current");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура НовыйПутьКИсполняемомуФайлу(ИдентификаторКлиента, ПутьКФайлу)
	Интеграция1СБухфон.СохранитьРасположениеИсполняемогоФайла1СБухфон(ИдентификаторКлиента, ПутьКФайлу);
КонецПроцедуры 

&НаСервереБезКонтекста
Процедура СохранитьНастройкиПользователяВХранилище(Логин, 
										 Пароль, 
										 СохранитьЛогинПароль,
										 ВидимостьКнопки)
																
	Интеграция1СБухфон.СохранитьНастройкиПользователяВХранилище(Логин, Пароль, СохранитьЛогинПароль, ВидимостьКнопки);

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ПриИзмененииНастроек()
	Интеграция1СБухфонПереопределяемый.ПриИзмененииНастроек();
КонецПроцедуры

// Выполняет инициализацию элементов формы в зависимости от
// настроек приложения.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ИнициализироватьЭлементыФормы(Форма)
	
	Форма.Элементы.ГруппаПараметрыЗапуска.Доступность = Форма.ВидимостьКнопки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбораЗавершение(НовыйПутьКФайлу, ДополнительныеПараметры) Экспорт
	Если НовыйПутьКФайлу <> "" Тогда
		ПутьКФайлу = НовыйПутьКФайлу;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти




