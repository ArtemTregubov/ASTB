////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	ЭтаФорма.Элементы.Работники.КоманднаяПанель.ПодчиненныеЭлементы.РаботникиПодборСотрудников.Доступность = НЕ Объект.Проведен;
	
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

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЭтаФорма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура РаботникиДолжностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Работники.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущееПодразделение = ПредопределенноеЗначение("Справочник.Подразделения.ПустаяСсылка");
	Иначе
		ТекущееПодразделение = ТекущиеДанные.Подразделение;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ДолжностиИПрофессии.ФормаВыбора",
			Новый Структура("СписокПрофессий", ПроцедурыРаботыСНормамиСервер.ПолучитьСписокПрофессийПоШтатномуРасписанию(Объект.Ссылка,ТекущееПодразделение)),Элемент);
			
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
Функция ВыгрузитьТаблицуДокументаВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Работники.Выгрузить(),ЭтаФорма.УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ПодборСотрудниковПодразделений(Команда)
	
	АдресВременногоХранилища = ВыгрузитьТаблицуДокументаВоВременноеХранилище();
	
	СтруктураДанных = ПолучитьДанныеПоПриказамНаМедосмотры(Объект.Организация,ПроцедурыРаботыСНормамиСервер.ПолучитьГраницуАнализаПоДокументу(Объект.Ссылка));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВременногоХранилищаТаблицы", 	АдресВременногоХранилища);
	ПараметрыФормы.Вставить("Организация", 						Объект.Организация);
	ПараметрыФормы.Вставить("Документ", 						Объект.Ссылка);
	ПараметрыФормы.Вставить("СписокДолжностей", 				СтруктураДанных.СписокДолжностей);
	ПараметрыФормы.Вставить("СписокПодразделений", 				СтруктураДанных.СписокПодразделений);
	ПараметрыФормы.Вставить("СписокРабочихМест", 				СтруктураДанных.СписокРабочихМест);
	
	ОткрытьФорму("Обработка.ПодборСотрудниковОрганизации.Форма.ФормаПодбора", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоПриказамНаМедосмотры(Организация,ДатаАнализа)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПриказыНаПроведениеМедицинскихОсмотровСрезПоследних.Подразделение КАК Подразделение,
	|	ПриказыНаПроведениеМедицинскихОсмотровСрезПоследних.Должность КАК Должность,
	|	ПриказыНаПроведениеМедицинскихОсмотровСрезПоследних.РабочееМесто КАК РабочееМесто
	|ИЗ
	|	РегистрСведений.ПриказыНаПроведениеМедицинскихОсмотров.СрезПоследних(&ДатаАнализа, Организация = &Организация) КАК ПриказыНаПроведениеМедицинскихОсмотровСрезПоследних
	|ГДЕ
	|	ПриказыНаПроведениеМедицинскихОсмотровСрезПоследних.Проводить";
	
	Запрос.УстановитьПараметр("ДатаАнализа",ДатаАнализа);
	Запрос.УстановитьПараметр("Организация",Организация);
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("СписокПодразделений",	ТаблицаЗапроса.ВыгрузитьКолонку("Подразделение"));
	СтруктураДанных.Вставить("СписокДолжностей",	ТаблицаЗапроса.ВыгрузитьКолонку("Должность"));
	СтруктураДанных.Вставить("СписокРабочихМест",	ТаблицаЗапроса.ВыгрузитьКолонку("РабочееМесто"));
	
	Возврат СтруктураДанных;
	
КонецФункции	

&НаСервере
Процедура ПолучитьРезультатПодбораИзХранилища(АдресРезультатаПодбораВХранилище)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТаблицаПодбора = ПолучитьИзВременногоХранилища(АдресРезультатаПодбораВХранилище);
	ТекущийОбъект.Работники.Загрузить(ТаблицаПодбора);		
	ЗначениеВРеквизитФормы(ТекущийОбъект,"Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборСотрудниковОрганизации.Форма.ФормаПодбора" Тогда
		
		ПолучитьРезультатПодбораИзХранилища(ВыбранноеЗначение.АдресРезультатаПодбораВХранилище);
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;

	Модифицированность = Истина;
		
КонецПроцедуры

&НаКлиенте
Процедура РаботникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры
