&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	МассивНоменклатурыНормы = ПолучитьМассивНоменклатурыНормы(Объект.НормаВыдачи);
	
	Элементы.НоменклатураНормы.СписокВыбора.ЗагрузитьЗначения(МассивНоменклатурыНормы);
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ГруппаТовары.ПодчиненныеЭлементы.Товары.КоманднаяПанель.ПодчиненныеЭлементы.ТоварыГруппаЗаполнить.Видимость = (ЗначениеЗаполнено(Объект.НормаВыдачи) И ЗначениеЗаполнено(Объект.НоменклатураНормы));
	
КонецПроцедуры	

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВА"

// СтандартныеПодсистемы.Свойства
 &НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "ПЕЧАТЬ"

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
  УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
  
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ...

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ЗаполнитьПоСкладуВыдачиНаСервере(ВыбранныйСклад)
	
	Документы.ЗачетВыданныхСредствЗащиты.ЗаполнитьТаблицуДокумента(Объект,"ПоСкладуВыдачи",ВыбранныйСклад);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСкладуВыдачи(Команда)
	
	Перем ВыбЗнач;
	
	//+++АСТБ_Горюшин_Алексей_19737
	ЗаголовокФормыВыбораСклада = НСтр("ru = 'Выберите склад выдачи'");
	//было
	//Заголовок = НСтр("ru = 'Выберите склад выдачи'");
	//---АСТБ_Горюшин_Алексей_19737
	
	Оповещение = Новый ОписаниеОповещения("ПослеВводаЗначенияСклада",ЭтаФорма,Параметры);
	
	//+++АСТБ_Горюшин_Алексей_19737
	ПоказатьВводЗначения(Оповещение, ВыбЗнач, ЗаголовокФормыВыбораСклада, Новый ОписаниеТипов("СправочникСсылка.Склады"));
	//было
	//ПоказатьВводЗначения(Оповещение,ВыбЗнач, Заголовок, Новый ОписаниеТипов("СправочникСсылка.Склады"));
	//---АСТБ_Горюшин_Алексей_19737
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаЗначенияСклада(ВыбЗнач,Параметры) Экспорт
	
	Если ВыбЗнач = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПоСкладуВыдачиНаСервере(ВыбЗнач);
			
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоМВЗНаСервере(ВыбранноеЗначение)
	
	Документы.ЗачетВыданныхСредствЗащиты.ЗаполнитьТаблицуДокумента(Объект,"ПоМВЗ",ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоМВЗ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Ложь);
	ПараметрыФормыВыбора.Вставить("Отбор",              Новый Структура("Владелец", Объект.Организация));
	
	ОткрытьФорму("Справочник.МВЗ.ФормаВыбора",ПараметрыФормыВыбора,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоСпискуСотрудниковНаСервере(СписокСотрудников)
	
	Документы.ЗачетВыданныхСредствЗащиты.ЗаполнитьТаблицуДокумента(Объект,"ПоСпискуСотрудников",СписокСотрудников);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСпискуСотрудников(Команда)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Владелец", Объект.Организация);
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		СтруктураОтбора.Вставить("Подразделение", Объект.Подразделение);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Должность) Тогда
		СтруктураОтбора.Вставить("Должность", Объект.Должность);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.РабочееМесто) Тогда
		СтруктураОтбора.Вставить("РабочееМесто", Объект.РабочееМесто);
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Отбор",СтруктураОтбора);
	
	ОткрытьФорму("Справочник.Сотрудники.ФормаВыбора",ПараметрыФормыВыбора,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.Сотрудники.Форма.ФормаВыбора" Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			ЗаполнитьПоСпискуСотрудниковНаСервере(ВыбранноеЗначение);
			
		КонецЕсли;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.МВЗ.Форма.ФормаВыбора" Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			ЗаполнитьПоМВЗНаСервере(ВыбранноеЗначение);
			
		КонецЕсли;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.НормыВыдачиСИЗ.Форма.ФормаВыбора" Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			ЗаполнитьПоНормамВыдачиНаСервере(ВыбранноеЗначение);
			
		КонецЕсли;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.НоменклатураНормОрганизации.Форма.ФормаВыбора" Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			ЗаполнитьПоНоменклатуреНормыНаСервере(ВыбранноеЗначение);
			
		КонецЕсли;	 
	//Танцюра А.Н. -- №142504 Доработка документа "Зачет выданных СИЗ" -- 03.11.2021 <<<	
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаВыбора" Тогда
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			
			ЗаполнитьПоНоменклатуреВыдачиНаСервере(ВыбранноеЗначение);
			
		КонецЕсли;	
	//Танцюра А.Н. -- №142504 Доработка документа "Зачет выданных СИЗ" -- 03.11.2021 >>>	
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;

	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоНормамВыдачиНаСервере(ВыбранноеЗначение)
	
	Документы.ЗачетВыданныхСредствЗащиты.ЗаполнитьТаблицуДокумента(Объект,"ПоНормамВыдачи",ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоНоменклатуреНормыНаСервере(ВыбранноеЗначение)
	
	Документы.ЗачетВыданныхСредствЗащиты.ЗаполнитьТаблицуДокумента(Объект,"ПоНоменклатуреНормы",ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОпциюОрганизации(Организация,НаименованиеОпции)
	
	Возврат Организация[НаименованиеОпции];
	
КонецФункции

&НаСервере
Функция ПолучитьСписокНоменклатурыВыдачи(НоменклатураНормы,Сотрудник)
	
	МассивСотрудников = Новый Массив;
	МассивСотрудников.Добавить(Сотрудник);
	
	ДатаАнализа = ПроцедурыРаботыСНормамиСервер.ПолучитьГраницуАнализаПоДокументу(Объект.Ссылка);
	
	ТаблицаЗанятыхРМ 			= ПроцедурыРаботыСНормамиСервер.ПолучитьТаблицуЗанятыхРабочихМестСУсловиями(МассивСотрудников,Объект.Организация,ДатаАнализа);
	ТаблицаУстановленныхНорм 	= ПроцедурыРаботыСНормамиСервер.ПолучитьТаблицуУстановленныхНорм(Объект.Организация,ДатаАнализа,ТаблицаЗанятыхРМ.ВыгрузитьКолонку("Подразделение"),ТаблицаЗанятыхРМ.ВыгрузитьКолонку("Должность"));
	ТаблицаСНормами 			= ПроцедурыРаботыСНормамиСервер.ПодобратьНормы(ТаблицаЗанятыхРМ,ТаблицаУстановленныхНорм.Скопировать(НОВЫЙ Структура("НоменклатураНормы",НоменклатураНормы)),Объект.Организация,ДатаАнализа,"Сотрудник,Подразделение,Должность,НоменклатураНормы,Использовать");
	
	ТаблицаСоответствия = ПроцедурыРаботыСНормамиСервер.ПолучитьСоответствияНоменклатурыДляСотрудника(ТаблицаСНормами,?(ЗначениеЗаполнено(Объект.Ссылка),ДатаАнализа,ТекущаяДата()),НоменклатураНормы);
	
	Возврат ТаблицаСоответствия.ВыгрузитьКолонку("Номенклатура");
	
КонецФункции

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	Объект.Товары.Очистить();
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииЯчейки(Элемент)
	
	Если Элементы.Товары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатура" Тогда
		
		ЭтаФорма.Элементы.Товары.ПодчиненныеЭлементы.ТоварыНоменклатура.СписокВыбора.ЗагрузитьЗначения(ПолучитьСписокНоменклатурыВыдачи(ТекущиеДанные.НоменклатураНормы,ТекущиеДанные.Сотрудник));
		
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатураНормы" Тогда	
		
		ЭтаФорма.Элементы.Товары.ПодчиненныеЭлементы.ТоварыНоменклатураНормы.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьСписокНоменклатурыНормыПоНормеВыдачи(ТекущиеДанные.НормаВыдачи));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНормаВыдачиПриИзменении(Элемент)
	
	Если Элементы.Товары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ТекущиеДанные.НоменклатураНормы 			= ПолучитьПервыйЭлементСостава(ТекущиеДанные.НормаВыдачи);
	ТекущиеДанные.Номенклатура 					= ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
	ТекущиеДанные.ХарактеристикаНоменклатуры 	= ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПервыйЭлементСостава(НормаВыдачи)
	
	Возврат НормаВыдачи.СоставНормы[0].НоменклатураНормы;
	
КонецФункции

&НаКлиенте
Процедура ТоварыНоменклатураНормыПриИзменении(Элемент)
	
	Если Элементы.Товары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ТекущиеДанные.Номенклатура 					= ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
	ТекущиеДанные.ХарактеристикаНоменклатуры 	= ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНормамВыдачи(Команда)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Владелец", Объект.Организация);
	СтруктураОтбора.Вставить("ВидВыдачиСИЗ", ПолучитьВидВыдачиСИЗ(Объект.НормаВыдачи));
	
	ПараметрыФормыВыбора.Вставить("Отбор",СтруктураОтбора);
	
	ОткрытьФорму("Справочник.НормыВыдачиСИЗ.ФормаВыбора",ПараметрыФормыВыбора,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВидВыдачиСИЗ(НормаВыдачи)
	
	Возврат НормаВыдачи.ВидВыдачиСИЗ;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПоНоменклатуреНормы(Команда)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Владелец", Объект.Организация);
	
	ПараметрыФормыВыбора.Вставить("Отбор",СтруктураОтбора);
	
	ОткрытьФорму("Справочник.НоменклатураНормОрганизации.ФормаВыбора",ПараметрыФормыВыбора,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Объект.Товары.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьПриИзменении(Элемент)
	
	Объект.Товары.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура РабочееМестоПриИзменении(Элемент)
	
	Объект.Товары.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура НормаВыдачиПриИзменении(Элемент)
	
	МассивНоменклатурыНормы = ПолучитьМассивНоменклатурыНормы(Объект.НормаВыдачи);
	
	Объект.НоменклатураНормы = МассивНоменклатурыНормы[0];
	
	Элементы.НоменклатураНормы.СписокВыбора.ЗагрузитьЗначения(МассивНоменклатурыНормы);
	
	УстановитьВидимостьЭлементов();
	
	ПересчитатьТаблицуДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьТаблицуДокумента()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Сотрудник КАК Сотрудник,
	|	ТаблицаДокумента.НормаВыдачи КАК НормаВыдачи,
	|	ТаблицаДокумента.НоменклатураНормы КАК НоменклатураНормы,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТаблицаДокумента.Количество КАК Количество,
	|	ТаблицаДокумента.ДатаВыдачи КАК ДатаВыдачи,
	|	ТаблицаДокумента.ДатаСледующейВыдачи КАК ДатаСледующейВыдачи
	|ПОМЕСТИТЬ ВТ_ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НормыВыдачиСИЗСоставНормы.ПериодичностьВыдачи.ТипПериода КАК ПериодичностьВыдачиТипПериода,
	|	НормыВыдачиСИЗСоставНормы.ПериодичностьВыдачи.КоличествоПериодов КАК ПериодичностьВыдачиКоличествоПериодов
	|ПОМЕСТИТЬ ВТ_Периодичность
	|ИЗ
	|	Справочник.НормыВыдачиСИЗ.СоставНормы КАК НормыВыдачиСИЗСоставНормы
	|ГДЕ
	|	НормыВыдачиСИЗСоставНормы.Ссылка = &НормаВыдачи
	|	И НормыВыдачиСИЗСоставНормы.НоменклатураНормы = &НоменклатураНормы
	|	И НормыВыдачиСИЗСоставНормы.Ссылка.Владелец = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТаблицаДокумента.Сотрудник КАК Сотрудник,
	|	ВТ_ТаблицаДокумента.НормаВыдачи КАК НормаВыдачи,
	|	ВТ_ТаблицаДокумента.НоменклатураНормы КАК НоменклатураНормы,
	|	ВТ_ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ВТ_ТаблицаДокумента.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВТ_ТаблицаДокумента.Количество КАК Количество,
	|	ВТ_ТаблицаДокумента.ДатаВыдачи КАК ДатаВыдачи,
	|	ВЫБОР
	|		КОГДА ВТ_Периодичность.ПериодичностьВыдачиТипПериода = ЗНАЧЕНИЕ(Перечисление.ДоступныеПериодыОтчета.Год)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ВТ_ТаблицаДокумента.ДатаВыдачи, МЕСЯЦ, ВТ_Периодичность.ПериодичностьВыдачиКоличествоПериодов * 12)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ВТ_ТаблицаДокумента.ДатаВыдачи, МЕСЯЦ, ВТ_Периодичность.ПериодичностьВыдачиКоличествоПериодов)
	|	КОНЕЦ КАК ДатаСледующейВыдачи
	|ИЗ
	|	ВТ_ТаблицаДокумента КАК ВТ_ТаблицаДокумента,
	|	ВТ_Периодичность КАК ВТ_Периодичность
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(ВЫБОР
	|				КОГДА ВТ_Периодичность.ПериодичностьВыдачиТипПериода = ЗНАЧЕНИЕ(Перечисление.ДоступныеПериодыОтчета.Год)
	|					ТОГДА ДОБАВИТЬКДАТЕ(ВТ_ТаблицаДокумента.ДатаВыдачи, МЕСЯЦ, ВТ_Периодичность.ПериодичностьВыдачиКоличествоПериодов * 12)
	|				ИНАЧЕ ДОБАВИТЬКДАТЕ(ВТ_ТаблицаДокумента.ДатаВыдачи, МЕСЯЦ, ВТ_Периодичность.ПериодичностьВыдачиКоличествоПериодов)
	|			КОНЕЦ, МЕСЯЦ) > НАЧАЛОПЕРИОДА(&ТекущаяДата, МЕСЯЦ)";
	
	Запрос.УстановитьПараметр("ТаблицаДокумента",	Объект.Товары.Выгрузить());
	Запрос.УстановитьПараметр("Организация",		Объект.Организация);
	Запрос.УстановитьПараметр("НормаВыдачи",		Объект.НормаВыдачи);
	Запрос.УстановитьПараметр("НоменклатураНормы",	Объект.НоменклатураНормы);
	Запрос.УстановитьПараметр("ТекущаяДата",	?(ЗначениеЗаполнено(Объект.Ссылка),Объект.Дата,ТекущаяДата()));
	
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМассивНоменклатурыНормы(НормаВыдачи)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыВыдачиСИЗСоставНормы.НоменклатураНормы КАК НоменклатураНормы
	|ИЗ
	|	Справочник.НормыВыдачиСИЗ.СоставНормы КАК НормыВыдачиСИЗСоставНормы
	|ГДЕ
	|	НормыВыдачиСИЗСоставНормы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", НормаВыдачи);
		
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НоменклатураНормы");
	
КонецФункции	

&НаКлиенте
Процедура НоменклатураНормыПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

//+++АСТБ_Горюшин_Алексей_19737
&НаСервере
Процедура СоздатьПриказыПоНормеВыдачиСИЗНаСервере()
	
	Если НЕ Объект.Проведен Тогда
		ТекстСообщения = "Сначала проведите Зачёт.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Приказ_Отмена_ДокументОбъект = Документы.ПриказПоНормамВыдачиСИЗ.СоздатьДокумент();
	ТЧ_Отмена = Приказ_Отмена_ДокументОбъект.НормыВыдачиСИЗ;
	
	Приказ_Установка_ДокументОбъект = Документы.ПриказПоНормамВыдачиСИЗ.СоздатьДокумент();
	ТЧ_Установка = Приказ_Установка_ДокументОбъект.НормыВыдачиСИЗ;
	
	Приказ_Отмена_ДокументОбъект.Организация		= Объект.Организация;
	Приказ_Отмена_ДокументОбъект.Комментарий		= "Сформирован из документа " + Объект.Ссылка;
	Приказ_Отмена_ДокументОбъект.ДокументОснование	= Объект.Ссылка;
	Приказ_Отмена_ДокументОбъект.СоздательДокумента	= Пользователи.ТекущийПользователь();
	Приказ_Отмена_ДокументОбъект.Ответственный		= Пользователи.ТекущийПользователь();
	
	Приказ_Установка_ДокументОбъект.Организация			= Объект.Организация;
	Приказ_Установка_ДокументОбъект.Комментарий			= "Сформирован из документа " + Объект.Ссылка;
	Приказ_Установка_ДокументОбъект.ДокументОснование	= Объект.Ссылка;
	Приказ_Установка_ДокументОбъект.СоздательДокумента	= Пользователи.ТекущийПользователь();
	Приказ_Установка_ДокументОбъект.Ответственный		= Пользователи.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗачетВыданныхСредствЗащитыТовары.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТ_Сотрудники
	|ИЗ
	|	Документ.ЗачетВыданныхСредствЗащиты.Товары КАК ЗачетВыданныхСредствЗащитыТовары
	|ГДЕ
	|	ЗачетВыданныхСредствЗащитыТовары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗачетВыданныхСредствЗащитыТовары.НормаВыдачи КАК НормаВыдачи
	|ПОМЕСТИТЬ ВТ_НормыВыдачи
	|ИЗ
	|	Документ.ЗачетВыданныхСредствЗащиты.Товары КАК ЗачетВыданныхСредствЗащитыТовары
	|ГДЕ
	|	ЗачетВыданныхСредствЗащитыТовары.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗачетВыданныхСредствЗащиты.НормаВыдачи
	|ИЗ
	|	Документ.ЗачетВыданныхСредствЗащиты КАК ЗачетВыданныхСредствЗащиты
	|ГДЕ
	|	ЗачетВыданныхСредствЗащиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗанятыеРабочиеМестаОстатки.Организация КАК Организация,
	|	ЗанятыеРабочиеМестаОстатки.Подразделение КАК Подразделение,
	|	ЗанятыеРабочиеМестаОстатки.Должность КАК Должность,
	|	ЗанятыеРабочиеМестаОстатки.РабочееМесто КАК РабочееМесто
	|ПОМЕСТИТЬ ВТ_ЗанятыеРабочиеМестаОстатки
	|ИЗ
	|	РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(
	|			,
	|			Организация = &Организация
	|				И Сотрудник В
	|					(ВЫБРАТЬ
	|						ВТ_Сотрудники.Сотрудник
	|					ИЗ
	|						ВТ_Сотрудники)) КАК ЗанятыеРабочиеМестаОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УстановленныеНормыВыдачиСИЗСрезПоследних.Организация КАК Организация,
	|	УстановленныеНормыВыдачиСИЗСрезПоследних.Подразделение КАК Подразделение,
	|	УстановленныеНормыВыдачиСИЗСрезПоследних.Должность КАК Должность,
	|	УстановленныеНормыВыдачиСИЗСрезПоследних.РабочееМесто КАК РабочееМесто,
	|	УстановленныеНормыВыдачиСИЗСрезПоследних.УсловиеНормы КАК УсловиеНормы,
	|	УстановленныеНормыВыдачиСИЗСрезПоследних.НормаВыдачи КАК НормаВыдачи
	|ИЗ
	|	ВТ_ЗанятыеРабочиеМестаОстатки КАК ВТ_ЗанятыеРабочиеМестаОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УстановленныеНормыВыдачиСИЗ.СрезПоследних(
	|				,
	|				Организация = &Организация
	|					И Подразделение В
	|						(ВЫБРАТЬ
	|							ВТ_ЗанятыеРабочиеМестаОстатки.Подразделение
	|						ИЗ
	|							ВТ_ЗанятыеРабочиеМестаОстатки)
	|					И Должность В
	|						(ВЫБРАТЬ
	|							ВТ_ЗанятыеРабочиеМестаОстатки.Должность
	|						ИЗ
	|							ВТ_ЗанятыеРабочиеМестаОстатки)
	|					И РабочееМесто В
	|						(ВЫБРАТЬ
	|							ВТ_ЗанятыеРабочиеМестаОстатки.РабочееМесто
	|						ИЗ
	|							ВТ_ЗанятыеРабочиеМестаОстатки)) КАК УстановленныеНормыВыдачиСИЗСрезПоследних
	|		ПО (УстановленныеНормыВыдачиСИЗСрезПоследних.Подразделение = ВТ_ЗанятыеРабочиеМестаОстатки.Подразделение)
	|			И (УстановленныеНормыВыдачиСИЗСрезПоследних.Должность = ВТ_ЗанятыеРабочиеМестаОстатки.Должность)
	|			И (УстановленныеНормыВыдачиСИЗСрезПоследних.РабочееМесто = ВТ_ЗанятыеРабочиеМестаОстатки.РабочееМесто)
	|ГДЕ
	|	УстановленныеНормыВыдачиСИЗСрезПоследних.Использовать = ИСТИНА
	|	И УстановленныеНормыВыдачиСИЗСрезПоследних.НормаВыдачи В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				ВТ_НормыВыдачи.НормаВыдачи
	|			ИЗ
	|				ВТ_НормыВыдачи)";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрока_Отмена = ТЧ_Отмена.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока_Отмена, ВыборкаДетальныеЗаписи);
		НоваяСтрока_Отмена.Использовать = Ложь;
		
		НоваяСтрока_Установка = ТЧ_Установка.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока_Установка, ВыборкаДетальныеЗаписи);
		НоваяСтрока_Установка.Использовать = Истина;
		
	КонецЦикла;
	
	НачатьТранзакцию();
	
	Попытка
		Приказ_Отмена_ДокументОбъект.Дата = ТекущаяДата();
		Приказ_Отмена_ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		ДатаДокумента = Приказ_Отмена_ДокументОбъект.Дата + 1;
		Приказ_Установка_ДокументОбъект.Дата = ДатаДокумента;
		Приказ_Установка_ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		ЗафиксироватьТранзакцию();
		ТекстСообщения = "Созданы документы: " + Символы.ПС + Приказ_Отмена_ДокументОбъект.Ссылка + Символы.ПС + Приказ_Установка_ДокументОбъект.Ссылка;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = "Документы не созданы!" + Символы.ПС + ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;		
	
КонецПроцедуры //---АСТБ_Горюшин_Алексей_19737

//+++АСТБ_Горюшин_Алексей_19737
&НаКлиенте
Процедура СоздатьПриказыПоНормеВыдачиСИЗ(Команда)
	СоздатьПриказыПоНормеВыдачиСИЗНаСервере();
КонецПроцедуры //---АСТБ_Горюшин_Алексей_19737

//Танцюра А.Н. -- №142504 Доработка документа "Зачет выданных СИЗ" -- 03.11.2021 <<<

&НаСервере
Процедура ЗаполнитьПолностьюНаСервере()
	
	Документы.ЗачетВыданныхСредствЗащиты.ЗаполнитьТаблицуДокумента(Объект,"Полностью",Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПолностью(Команда)
	
	ЗаполнитьПолностьюНаСервере(); 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоНоменклатуреВыдачиНаСервере(ВыбранноеЗначение)
	
	Документы.ЗачетВыданныхСредствЗащиты.ЗаполнитьТаблицуДокумента(Объект,"ПоНоменклатуреВыдачи",ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНоменклатуреВыдачи(Команда)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	
	СтруктураОтбора = Новый Структура;
	
	ПараметрыФормыВыбора.Вставить("Отбор",СтруктураОтбора);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",ПараметрыФормыВыбора,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПроизвольнойВыдачеНаСервере()
	
    Документы.ЗачетВыданныхСредствЗащиты.ЗаполнитьТаблицуДокумента(Объект,"ПоПроизвольнойВыдаче",Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПроизвольнойВыдаче(Команда)
	
	ЗаполнитьПоПроизвольнойВыдачеНаСервере(); 
	
КонецПроцедуры

//Танцюра А.Н. -- №142504 Доработка документа "Зачет выданных СИЗ" -- 03.11.2021 >>>