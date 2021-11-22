
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ШаблонАнкеты") Тогда
		Отказ = Истина;
		Возврат;
	Иначе
		ШаблонАнкеты = Параметры.ШаблонАнкеты;
	КонецЕсли;
	
	УстановитьЗначенияРеквизитовФормыСогласноШаблонаАнкеты();
	Анкетирование.УстановитьЭлементДереваРазделовАнкетыВступлениеЗаключение(ДеревоРазделов,"Вступление");
	Анкетирование.ЗаполнитьДеревоРазделов(ЭтотОбъект,ДеревоРазделов);
	Анкетирование.УстановитьЭлементДереваРазделовАнкетыВступлениеЗаключение(ДеревоРазделов,"Заключение");
	АнкетированиеКлиентСервер.СформироватьНумерациюДерева(ДеревоРазделов,Истина);
	
	Элементы.ДеревоРазделов.ТекущаяСтрока = 0;
	ПостроениеФормыСогласноРаздела();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностьюКнопкиНавигацияРазделов();
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоРазделовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоРазделов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПостроениеФормыЗаполнения();
	УправлениеДоступностьюКнопкиНавигацияРазделов();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииВопросовСУсловием(Элемент)

	УправлениеДоступностьюПодчиненныеВопросы();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкрытьПоказатьДеревоРазделов(Команда)

	ИзменитьВидимостьДеревоРазделов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийРаздел(Команда)
	
	ИзменитьРаздел("Назад");
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийРаздел(Команда)
	
	ИзменитьРаздел("Вперед");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборРаздела(Команда)
	
	ВыполнитьПостроениеФормыЗаполнения();
	УправлениеДоступностьюКнопкиНавигацияРазделов();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

// Отвечает за построение формы заполнения.
&НаСервере
Процедура ПостроениеФормыСогласноРаздела()
	
	// Определение выбранного раздела.
	ТекущиеДанныеДеревоРазделов = ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока);
	Если ТекущиеДанныеДеревоРазделов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НомерТекущегоРаздела = Элементы.ДеревоРазделов.ТекущаяСтрока;
	Анкетирование.ПостроениеФормыЗаполненияПоРазделу(ЭтотОбъект,ТекущиеДанныеДеревоРазделов);
	Анкетирование.СформироватьТаблицуПодчиненияВопросов(ЭтотОбъект);
	
	Элементы.ПредыдущийРазделПодвал.Видимость = (ТаблицаВопросовРаздела.Количество() > 0);
	Элементы.СледующийРазделПодвал.Видимость  = (ТаблицаВопросовРаздела.Количество() > 0);
	
	АнкетированиеКлиентСервер.ПереключитьВидимостьГруппТелаАнкеты(ЭтотОбъект, Истина);
	
КонецПроцедуры

// Начинает процесс построения формы заполнения согласно разделам.
&НаКлиенте
Процедура ВыполнитьПостроениеФормыЗаполнения()
	
	АнкетированиеКлиентСервер.ПереключитьВидимостьГруппТелаАнкеты(ЭтотОбъект, Ложь);
	ПодключитьОбработчикОжидания("ОкончаниеПостроенияФормыЗаполнения",0.1,Истина);
	
КонецПроцедуры

// Заканчивает формирование формы заполнения анкеты.
&НаКлиенте
Процедура ОкончаниеПостроенияФормыЗаполнения()
	
	ПостроениеФормыСогласноРаздела();
	УправлениеДоступностьюПодчиненныеВопросы();
	УправлениеДоступностьюКнопкиНавигацияРазделов();
	
КонецПроцедуры

// Отвечает за доступность кнопок навигации по разделам.
&НаКлиенте
Процедура УправлениеДоступностьюКнопкиНавигацияРазделов()
	
	Элементы.ПредыдущийРаздел.Доступность       = (Элементы.ДеревоРазделов.ТекущаяСтрока <> 0);
	Элементы.ПредыдущийРазделПодвал.Доступность = (Элементы.ДеревоРазделов.ТекущаяСтрока > 0);
	Элементы.СледующийРаздел.Доступность        = (ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока +  1) <> Неопределено);
	Элементы.СледующийРазделПодвал.Доступность  = (ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока +  1) <> Неопределено);
	
КонецПроцедуры

// Изменяет текущий раздел
&НаКлиенте
Процедура ИзменитьРаздел(Направление)
	
	Элементы.ДеревоРазделов.ТекущаяСтрока = НомерТекущегоРаздела + ?(Направление = "Вперед",1,-1);
	НомерТекущегоРаздела = НомерТекущегоРаздела + ?(Направление = "Вперед",1,-1);
	ТекущиеДанныеДеревоРазделов = ДеревоРазделов.НайтиПоИдентификатору(Элементы.ДеревоРазделов.ТекущаяСтрока);
	Если ТекущиеДанныеДеревоРазделов.КоличествоВопросов = 0 И ТекущиеДанныеДеревоРазделов.ТипСтроки = "Раздел"  Тогда
		ИзменитьРаздел(Направление);
	КонецЕсли;
	ВыполнитьПостроениеФормыЗаполнения();
	
КонецПроцедуры

// Изменяет видимость дерева разделов.
&НаКлиенте
Процедура ИзменитьВидимостьДеревоРазделов()

	Элементы.ГруппаДеревоРазделов.Видимость         = НЕ Элементы.ГруппаДеревоРазделов.Видимость;
	Элементы.СкрытьПоказатьДеревоРазделов.Заголовок = ?(Элементы.ГруппаДеревоРазделов.Видимость,НСтр("ru = 'Скрыть разделы'"), НСтр("ru = 'Показать разделы'"));

КонецПроцедуры 

// Управляет доступностью элементов формы.
&НаКлиенте
Процедура УправлениеДоступностьюПодчиненныеВопросы()
	
	Для каждого ЭлементКоллекции Из ПодчиненныеВопросы Цикл
		
		ИмяВопроса = АнкетированиеКлиентСервер.ПолучитьИмяВопроса(ЭлементКоллекции.Вопрос);
		
		Для каждого ПодчиненныйВопрос Из ЭлементКоллекции.Подчиненные Цикл
			
			Элементы[ПодчиненныйВопрос.ИмяЭлементаПодчиненногоВопроса].ТолькоПросмотр           = (НЕ ЭтотОбъект[ИмяВопроса]);
			Если СтрЧислоВхождений(ПодчиненныйВопрос.ИмяЭлементаПодчиненногоВопроса,"Реквизит") = 0 Тогда
				
				Попытка
					Элементы[ПодчиненныйВопрос.ИмяЭлементаПодчиненногоВопроса].АвтоОтметкаНезаполненного = (ЭтотОбъект[ИмяВопроса] И ПодчиненныйВопрос.Обязательный);
				Исключение
					// У флажка и переключателя нет свойства АвтоОтметкаНезаполненного.
				КонецПопытки;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры 

// Устанавливает значения реквизитов формы, определенных в шаблоне анкеты.
//
&НаСервере
Процедура УстановитьЗначенияРеквизитовФормыСогласноШаблонаАнкеты()

	РеквизитыШаблонАнкеты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ШаблонАнкеты,"Заголовок,Вступление,Заключение");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,РеквизитыШаблонАнкеты);

КонецПроцедуры

#КонецОбласти
