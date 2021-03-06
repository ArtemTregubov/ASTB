&НаКлиенте
Перем ИзмененыДоступныеУсловия;

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
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	ЗаполнитьАнтропометрию();
	
	УстановитьПривилегированныйРежим(Истина);
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
			ВнешнийПользователь = Справочники.ВнешниеПользователи.НайтиПоРеквизиту("ОбъектАвторизации",Объект.ФизическоеЛицо);
			Если ВнешнийПользователь.Пустая() Тогда
				Элементы.ФормаОтправитьУведомление.Видимость = Ложь;
			Иначе
				Элементы.ФормаОтправитьУведомление.Видимость = ОтправкаPUSHВызовСервера.МожноОтправлятьУведомления(ВнешнийПользователь);
			КонецЕсли;
		Иначе
			Элементы.ФормаОтправитьУведомление.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ФормаОтправитьУведомление.Видимость = Ложь;
	КонецЕсли;	
	
	ИспользоватьПодключаемоеОборудование = ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование");
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства

	//создана подписка на событие "СотрудникиПередЗаписью"
	//Если НЕ ПроцедурыРаботыСНормамиСервер.ПроверитьУникальностьМагнитногоКода(
	//	ДанныеФормыВЗначение(Объект,Тип("СправочникОбъект.Сотрудники"))) Тогда
	//	ТекстСообщения = НСтр("ru = 'Карта с данным номером уже зарегистрирована в системе'");
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,Объект.Ссылка,"Идентификатор");
	//	Отказ = Истина;
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	ТаблицаАнтропометрии = РеквизитФормыВЗначение("АнтропометрическиеСвойства",Тип("ТаблицаЗначений"));
	
	Для Каждого СтрокаАнтропометрии Из ТаблицаАнтропометрии Цикл
		
		НаборЗаписей = РегистрыСведений.ЗначенияАнтропометрическихСвойств.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сотрудник.Установить(ТекущийОбъект.Ссылка);
		НаборЗаписей.Отбор.ВидСвойства.Установить(СтрокаАнтропометрии.ВидСвойства);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 0 Тогда
			
			Если ЗначениеЗаполнено(СтрокаАнтропометрии.ЗначениеСвойства) Тогда
				НоваяЗапись 			 		= НаборЗаписей.Добавить();
				НоваяЗапись.Сотрудник 			= ТекущийОбъект.Ссылка;
				НоваяЗапись.ВидСвойства 		= СтрокаАнтропометрии.ВидСвойства;
				НоваяЗапись.ЗначениеСвойства	= СтрокаАнтропометрии.ЗначениеСвойства;
				НаборЗаписей.Записать();
			КонецЕсли;
		
		Иначе
			
			Если ЗначениеЗаполнено(СтрокаАнтропометрии.ЗначениеСвойства) Тогда
				ЗаписьРегистра 					= НаборЗаписей[0];
				ЗаписьРегистра.ЗначениеСвойства = СтрокаАнтропометрии.ЗначениеСвойства;
				НаборЗаписей.Записать();
			Иначе
				НаборЗаписей.Очистить();
				НаборЗаписей.Записать();
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьАнтропометриюСотрудника" Тогда
		ЗаполнитьАнтропометрию();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "TracksData" Тогда
			Если Параметр[1][3] <> Неопределено Тогда
				Объект.Идентификатор = Параметр[1][3][0].ДанныеДорожек[0].ЗначениеПоля;
			Иначе
				Объект.Идентификатор = Параметр[0];
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВА"

// СтандартныеПодсистемы.Свойства
 &НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

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

&НаКлиенте
Процедура АнтропометрическиеСвойстваПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.АнтропометрическиеСвойства.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.АнтропометрическиеСвойства.ПодчиненныеЭлементы.АнтропометрическиеСвойстваЗначениеСвойства.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивДопустимыхЗначений(ТекущиеДанные.ВидСвойства));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАнтропометрию()
	
	АнтропометрическиеСвойства.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыАнтропометрическихСвойств.Ссылка КАК ВидСвойства,
	|	ЕСТЬNULL(ЗначенияАнтропометрическихСвойств.ЗначениеСвойства, """") КАК ЗначениеСвойства
	|ИЗ
	|	Справочник.ВидыАнтропометрическихСвойств КАК ВидыАнтропометрическихСвойств
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗначенияАнтропометрическихСвойств.ВидСвойства КАК ВидСвойства,
	|			ЗначенияАнтропометрическихСвойств.ЗначениеСвойства КАК ЗначениеСвойства
	|		ИЗ
	|			РегистрСведений.ЗначенияАнтропометрическихСвойств КАК ЗначенияАнтропометрическихСвойств
	|		ГДЕ
	|			ЗначенияАнтропометрическихСвойств.Сотрудник = &Сотрудник) КАК ЗначенияАнтропометрическихСвойств
	|		ПО ВидыАнтропометрическихСвойств.Ссылка = ЗначенияАнтропометрическихСвойств.ВидСвойства
	|ГДЕ
	|	НЕ ВидыАнтропометрическихСвойств.Ссылка = ЗНАЧЕНИЕ(Справочник.ВидыАнтропометрическихСвойств.НеОпределен)";
	
	Запрос.УстановитьПараметр("Сотрудник",Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	АнтропометрическиеСвойства.Загрузить(Запрос.Выполнить().Выгрузить());
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивДопустимыхЗначений(ВидСвойства)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДопустимыеЗначенияАнтропометрическихСвойств.ДопустимоеЗначение
	|ИЗ
	|	РегистрСведений.ДопустимыеЗначенияАнтропометрическихСвойств КАК ДопустимыеЗначенияАнтропометрическихСвойств
	|ГДЕ
	|	ДопустимыеЗначенияАнтропометрическихСвойств.ВидСвойства = &ВидСвойства
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДопустимыеЗначенияАнтропометрическихСвойств.ДопустимоеЗначение";
	
	Запрос.УстановитьПараметр("ВидСвойства",ВидСвойства);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДопустимоеЗначение");
	
КонецФункции

&НаКлиенте
Процедура АнтропометрическиеСвойстваПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьИнформациюОбОсновномМестеРаботы();
	
	ИзмененыДоступныеУсловия = Ложь;
	
	ЭтаФорма.Элементы.МестоХраненияСИЗ.СписокВыбора.ЗагрузитьЗначения(ПроцедурыРаботыСНормамиСервер.ПолучитьМассивДоступныхМестХраненияСИЗ(Объект.Ссылка));
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьИнформациюОбОсновномМестеРаботы()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Элементы.ИнформацияОбОсновномМестеРаботы.Заголовок = ПроцедурыРаботыСНормамиСервер.СформироватьИнформациюОбОсновномМестеРаботыНаСервере(Объект.Ссылка);
		
	Иначе	
		
		Элементы.ИнформацияОбОсновномМестеРаботы.Заголовок = "Основное место работы не определено";
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АнтропометрическиеСвойстваЗначениеСвойстваОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если Элемент.СписокВыбора.НайтиПоЗначению(Элемент.ТекстРедактирования) = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
    ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура ОтправитьУведомление(Команда)
	
	ПараметрыФормы = Новый Структура("ФизическоеЛицо",Объект.ФизическоеЛицо);
	
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаОтправкиУведомления",ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	                                                                                                          
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАнкеты(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Респондент",Объект.ФизическоеЛицо);
	
	ОткрытьФорму("Обработка.СписокРеспондента.Форма.Форма",ПараметрыФормы,ЭтаФорма,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
