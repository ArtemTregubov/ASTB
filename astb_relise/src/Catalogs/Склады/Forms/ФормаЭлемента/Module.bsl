////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Рохин Задача(76476)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "ГруппаКонтактнаяИнформация", ПоложениеЗаголовкаЭлементаФормы.Лево);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	// Рохин Задача(76476)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	УстановитьПривилегированныйРежим(Истина);
	
	//АСТБ_ALEX_**************************************************************
	//обмен с сап
	СтруктураУстанавливаемыхПараметров = Новый Структура;
	СтруктураУстанавливаемыхПараметров.Вставить("ИспользоватьСинхронизациюДанныхСАП",Константы.ИспользоватьСинхронизациюДанныхСАП.Получить());
	УстановитьПараметрыФункциональныхОпцийФормы(СтруктураУстанавливаемыхПараметров);
	//АСТБ_ALEX_**************************************************************
	
	УстановитьПривилегированныйРежим(Ложь);
	
	УстановитьДоступностьЭлементов();
	УстановитьВидимостьЭлементов();
	
	ДатаГрафика = ТекущаяДата();
	
	Элементы.ДатаГрафика.НачалоПериодаОтображения 	= НачалоГода(ДатаГрафика);
	Элементы.ДатаГрафика.КонецПериодаОтображения	= КонецГода(ДатаГрафика);
	
	ПериодЗаполнения.ДатаНачала 	= НачалоГода(ДатаГрафика);
	ПериодЗаполнения.ДатаОкончания 	= КонецГода(ДатаГрафика);
	ПериодЗаполнения.Вариант		= ВариантСтандартногоПериода.ЭтотГод;
	
	УчитыватьПраздники = Истина;
	
	ЗаполнитьДниГрафика();
	
	ЗаполнитьТекущиеПараметры();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекущиеПараметры()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ГрафикРаботыСклада.КоличествоОкон КАК КоличествоОкон,
	|	ГрафикРаботыСклада.ВремяОбслуживания КАК ВремяОбслуживания,
	|	ГрафикРаботыСклада.НачалоРаботы КАК НачалоРаботы,
	|	ГрафикРаботыСклада.ОкончаниеРаботы КАК ОкончаниеРаботы
	|ИЗ
	|	РегистрСведений.ГрафикРаботыСклада КАК ГрафикРаботыСклада
	|ГДЕ
	|	ГрафикРаботыСклада.Склад = &Склад
	|	И ГрафикРаботыСклада.День = &День
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаписиНаСкладСрезПоследних.Сотрудник) КАК КоличествоЗаписанных,
	|	ЗаписиНаСкладСрезПоследних.Время КАК Время
	|ИЗ
	|	РегистрСведений.ЗаписиНаСклад.СрезПоследних(
	|			,
	|			Склад = &Склад
	|				И День = &День) КАК ЗаписиНаСкладСрезПоследних
	|ГДЕ
	|	ЗаписиНаСкладСрезПоследних.Использовать
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаписиНаСкладСрезПоследних.Время
	|
	|УПОРЯДОЧИТЬ ПО
	|	Время";
	
	Запрос.УстановитьПараметр("Склад",	Объект.Ссылка);
	Запрос.УстановитьПараметр("День",	ДатаГрафика);
	
	Результат = Запрос.ВыполнитьПакет();
	
	График = Результат[0].Выгрузить();
	Записи = Результат[1].Выгрузить();
	
	Если График.Количество() = 0 Тогда
		ТекущиеПараметрыРаботы = "График работы не задан.";
	Иначе
		ТекущиеПараметрыРаботы = "Количество окон: " + График[0].КоличествоОкон + ". Время обслуживания: " + График[0].ВремяОбслуживания + " мин. Время работы: с " + Формат(График[0].НачалоРаботы,"ДФ=ЧЧ:мм") + " по " + Формат(График[0].ОкончаниеРаботы,"ДФ=ЧЧ:мм") + ".";
		Если Записи.Количество() = 0 Тогда
			ТекущиеПараметрыРаботы = ТекущиеПараметрыРаботы + " Записи отсутствуют.";
		Иначе
			ТекстЗаписей = "Записано: ";
			Для Каждого СтрокаЗаписи Из Записи Цикл
				ТекстЗаписей = ТекстЗаписей + Формат(СтрокаЗаписи.Время,"ДФ=ЧЧ:мм") + " - " + СтрокаЗаписи.КоличествоЗаписанных + ". ";
			КонецЦикла;
			ТекущиеПараметрыРаботы = ТекущиеПараметрыРаботы + ТекстЗаписей;
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДниГрафика()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ГрафикРаботыСклада.День КАК День
	|ИЗ
	|	РегистрСведений.ГрафикРаботыСклада КАК ГрафикРаботыСклада
	|ГДЕ
	|	ГрафикРаботыСклада.Склад = &Склад";
	
	Запрос.УстановитьПараметр("Склад",Объект.Ссылка);
	
	ДниГрафика.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("День"));
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОстаткиНоменклатуры.Склад КАК Склад
	|ИЗ
	|	РегистрНакопления.ОстаткиНоменклатуры КАК ОстаткиНоменклатуры
	|ГДЕ
	|	ОстаткиНоменклатуры.Склад = &Склад";
	
	Запрос.УстановитьПараметр("Склад",Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	
	//Элементы.АвтоматизированнаяВыдача.Доступность = Результат.Пустой();
	
КонецПроцедуры	
	
&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ГруппаАвтоматизированнаяВыдача.Видимость 	= Объект.АвтоматизированнаяВыдача;
	Элементы.СкладОтправитель1.Видимость				= НЕ Объект.АвтоматизированнаяВыдача;							
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Рохин Задача(76476)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
	// Рохин Задача(76476)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Рохин Задача(76476)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
	// Рохин Задача(76476)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Рохин Задача(76476)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
	// Рохин Задача(76476)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Рохин Задача(76476)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
	// Рохин Задача(76476)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	
	Если ИмяСобытия = "ЗакрытиеФормыЗаписиГрафика" Тогда
		ЗаполнитьДниГрафика();
		Элементы.ДатаГрафика.Обновить();
		ЗаполнитьТекущиеПараметры();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "КОНТАКТНАЯ ИНФОРМАЦИЯ"
// СтандартныеПодсистемы.КонтактнаяИнформация
// Рохин Задача(76476)
	
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат )
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

// Рохин Задача(76476)
// Конец СтандартныеПодсистемы.КонтактнаяИнформация


// СтандартныеПодсистемы.Свойства
 &НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ...

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
    ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура АвтоматизированнаяВыдачаПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГрафикРаботыНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеПроизводственногоКалендаря.Дата КАК Дата
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
	|	И ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И (ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
	|			ИЛИ ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
	|			ИЛИ ВЫБОР
	|				КОГДА НЕ &УчитыватьПраздники
	|					ТОГДА ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Праздник)
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь",	Объект.ПроизводственныйКалендарь);
	Запрос.УстановитьПараметр("НачалоПериода",				ПериодЗаполнения.ДатаНачала);
	Запрос.УстановитьПараметр("ОкончаниеПериода",			ПериодЗаполнения.ДатаОкончания);
	Запрос.УстановитьПараметр("УчитыватьПраздники",			УчитыватьПраздники);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "За заданный период производственный календарь не заполнен!";
		СообщениеПользователю.Сообщить();
		Возврат;
		
	КонецЕсли;
	
	ТаблицаЗапроса = Результат.Выгрузить();
	
	Для Каждого СтрокаТаблицыЗапроса Из ТаблицаЗапроса Цикл
		
		НаборЗаписей = РегистрыСведений.ГрафикРаботыСклада.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Склад.Установить(Объект.Ссылка);
		НаборЗаписей.Отбор.День.Установить(СтрокаТаблицыЗапроса.Дата);
		НаборЗаписей.Прочитать();
		
		МожноЗаписывать = Истина;
		
		Если НаборЗаписей.Количество() = 0 Тогда
			
			НоваяЗапись 					= НаборЗаписей.Добавить();
			НоваяЗапись.Склад 				= Объект.Ссылка;
			НоваяЗапись.День 				= СтрокаТаблицыЗапроса.Дата;
			НоваяЗапись.КоличествоОкон		= Объект.КоличествоОкон;
			НоваяЗапись.ВремяОбслуживания 	= Объект.ВремяОбслуживания;
			НоваяЗапись.НачалоРаботы 		= Объект.НачалоРаботы;
			НоваяЗапись.ОкончаниеРаботы 	= Объект.ОкончаниеРаботы;
			НоваяЗапись.НачалоПерерыва 		= Объект.НачалоПерерыва;
			НоваяЗапись.ОкончаниеПерерыва 	= Объект.ОкончаниеПерерыва;
			
		Иначе
			
			МожноЗаписывать = МожноМенять(СтрокаТаблицыЗапроса.Дата,Объект.КоличествоОкон,Объект.ВремяОбслуживания,Объект.НачалоРаботы,Объект.ОкончаниеРаботы);
			
			НаборЗаписей[0].КоличествоОкон		= Объект.КоличествоОкон;
			НаборЗаписей[0].ВремяОбслуживания 	= Объект.ВремяОбслуживания;
			НаборЗаписей[0].НачалоРаботы 		= Объект.НачалоРаботы;
			НаборЗаписей[0].ОкончаниеРаботы 	= Объект.ОкончаниеРаботы;
			НаборЗаписей[0].НачалоПерерыва 		= Объект.НачалоПерерыва;
			НаборЗаписей[0].ОкончаниеПерерыва 	= Объект.ОкончаниеПерерыва;
			
		КонецЕсли;
		
		Если МожноЗаписывать Тогда
			НаборЗаписей.Записать();
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры

Функция МожноМенять(ДатаДляЗаписи,КоличествоОкон,ВремяОбслуживания,НачалоРаботы,ОкончаниеРаботы)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаписиНаСкладСрезПоследних.Организация КАК Организация,
	|	ЗаписиНаСкладСрезПоследних.Склад КАК Склад,
	|	ЗаписиНаСкладСрезПоследних.День КАК День,
	|	ЗаписиНаСкладСрезПоследних.Сотрудник КАК Сотрудник,
	|	ЗаписиНаСкладСрезПоследних.Время КАК Время
	|ПОМЕСТИТЬ ВТ_ЗаписиНаСклад
	|ИЗ
	|	РегистрСведений.ЗаписиНаСклад.СрезПоследних(
	|			,
	|			Склад = &Склад
	|				И День = &День) КАК ЗаписиНаСкладСрезПоследних
	|ГДЕ
	|	ЗаписиНаСкладСрезПоследних.Использовать
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ЗаписиНаСклад.Организация КАК Организация,
	|	ВТ_ЗаписиНаСклад.Склад КАК Склад,
	|	ВТ_ЗаписиНаСклад.День КАК День,
	|	ВТ_ЗаписиНаСклад.Время КАК Время,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_ЗаписиНаСклад.Сотрудник) КАК КоличествоСотрудников
	|ПОМЕСТИТЬ ВТ_КоличествоЗаписей
	|ИЗ
	|	ВТ_ЗаписиНаСклад КАК ВТ_ЗаписиНаСклад
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ЗаписиНаСклад.Организация,
	|	ВТ_ЗаписиНаСклад.Склад,
	|	ВТ_ЗаписиНаСклад.День,
	|	ВТ_ЗаписиНаСклад.Время
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВТ_КоличествоЗаписей.КоличествоСотрудников) КАК МаксимальноеКоличествоЗаписей,
	|	ВТ_КоличествоЗаписей.Склад КАК Склад,
	|	ВТ_КоличествоЗаписей.День КАК День
	|ИЗ
	|	ВТ_КоличествоЗаписей КАК ВТ_КоличествоЗаписей
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_КоличествоЗаписей.Склад,
	|	ВТ_КоличествоЗаписей.День";
	
	Запрос.УстановитьПараметр("Склад",	Объект.Ссылка);
	Запрос.УстановитьПараметр("День",	ДатаДляЗаписи);
	
	РезультатЗапросаПоЗаписям = Запрос.Выполнить();
	
	Если РезультатЗапросаПоЗаписям.Пустой() Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТаблицаЗапроса = РезультатЗапросаПоЗаписям.Выгрузить();
	
	//Если КоличествоОкон < ТаблицаЗапроса[0].МаксимальноеКоличествоЗаписей Тогда //количество окон уменьшать нельзя
	//	
	//	Возврат Ложь;
	//	
	//КонецЕсли;
	
	//получаем старые условия времени
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ГрафикРаботыСклада.ВремяОбслуживания КАК ВремяОбслуживания,
	|	ГрафикРаботыСклада.НачалоРаботы КАК НачалоРаботы,
	|	ГрафикРаботыСклада.ОкончаниеРаботы КАК ОкончаниеРаботы
	|ИЗ
	|	РегистрСведений.ГрафикРаботыСклада КАК ГрафикРаботыСклада
	|ГДЕ
	|	ГрафикРаботыСклада.Склад = &Склад
	|	И ГрафикРаботыСклада.День = &День";
	
	Запрос.УстановитьПараметр("Склад",	Объект.Ссылка);
	Запрос.УстановитьПараметр("День",	ДатаДляЗаписи);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТаблицаЗапроса = Результат.Выгрузить();
	
	Если НЕ ТаблицаЗапроса[0].ВремяОбслуживания = ВремяОбслуживания Тогда
		
		Если НЕ РезультатЗапросаПоЗаписям.Пустой() Тогда//время обслуживания менять нельзя
			
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
	//проверка записей на время
	//Если НЕ ТаблицаЗапроса[0].НачалоРаботы = НачалоРаботы ИЛИ НЕ ТаблицаЗапроса[0].ОкончаниеРаботы = ОкончаниеРаботы Тогда
	//	
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = 
	//	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	//	|	ЗаписиНаСкладСрезПоследних.Время КАК Время
	//	|ИЗ
	//	|	РегистрСведений.ЗаписиНаСклад.СрезПоследних(
	//	|			,
	//	|			Склад = &Склад
	//	|				И День = &День) КАК ЗаписиНаСкладСрезПоследних
	//	|ГДЕ
	//	|	ЗаписиНаСкладСрезПоследних.Использовать
	//	|
	//	|УПОРЯДОЧИТЬ ПО
	//	|	Время";
	//	
	//	Запрос.УстановитьПараметр("Склад",	Объект.Ссылка);
	//	Запрос.УстановитьПараметр("День",	ДатаДляЗаписи);
	//	
	//	Результат = Запрос.Выполнить();
	//	
	//	Если Результат.Пустой() Тогда
	//		Возврат Истина;
	//	КонецЕсли;
	//	
	//	ТаблицаЗапроса = Результат.Выгрузить();
	//	
	//	МассивЗанятогоВремени = ТаблицаЗапроса.ВыгрузитьКолонку("Время");
	//	
	//	НачалоРабочегоДня = Дата(1,1,1,Час(НачалоРаботы),Минута(НачалоРаботы),0);
	//	КонецРабочегоДня = Дата(1,1,1,Час(ОкончаниеРаботы),Минута(ОкончаниеРаботы),0);
	//	
	//	ЕстьЗаписи = Ложь;
	//	
	//	Для Каждого Время Из МассивЗанятогоВремени Цикл
	//		
	//		Если Время < НачалоРабочегоДня ИЛИ Время > КонецРабочегоДня Тогда
	//		    ЕстьЗаписи = Истина;
	//			Прервать;
	//		КонецЕсли;
	//		
	//	КонецЦикла;
	//	
	//	Если ЕстьЗаписи Тогда
	//		
	//		Возврат Ложь;
	//		
	//	Иначе
	//		
	//		Возврат Истина;
	//		
	//	КонецЕсли;
	//	
	//Иначе
	//	
	//	Возврат Истина;
	//	
	//КонецЕсли;	
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьГрафикРаботы(Команда)
	
	НетОшибок = Истина;
	
	Если НЕ ЗначениеЗаполнено(Объект.ПроизводственныйКалендарь) Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Не заполнен производственный календарь!";
		СообщениеПользователю.Сообщить();
		НетОшибок = Ложь;
	КонецЕсли;	
	
	Если Объект.КоличествоОкон = 0 Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Не задано количество окон!";
		СообщениеПользователю.Сообщить();
		НетОшибок = Ложь;		
	КонецЕсли;	
	
	Если Объект.ВремяОбслуживания = 0 Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Не задано время обслуживания!";
		СообщениеПользователю.Сообщить();
		НетОшибок = Ложь;		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.НачалоРаботы) ИЛИ НЕ ЗначениеЗаполнено(Объект.ОкончаниеРаботы) ИЛИ Объект.НачалоРаботы > Объект.ОкончаниеРаботы Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Неверно задано время работы!";
		СообщениеПользователю.Сообщить();
		НетОшибок = Ложь;		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.НачалоПерерыва) И НЕ ЗначениеЗаполнено(Объект.ОкончаниеПерерыва) И Объект.НачалоПерерыва > Объект.ОкончаниеПерерыва Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Неверно задано время перерыва!";
		СообщениеПользователю.Сообщить();
		НетОшибок = Ложь;		
	КонецЕсли;
	
	Если НЕ НетОшибок Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьГрафикРаботыНаСервере();
	ЗаполнитьДниГрафика();
	
	Элементы.ДатаГрафика.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОбслуживанияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	
	Если Направление = 1 Тогда
		Объект.ВремяОбслуживания = Объект.ВремяОбслуживания + 5;
	Иначе
		Объект.ВремяОбслуживания = Объект.ВремяОбслуживания - 5;
	КонецЕсли;		
	
	Объект.ВремяОбслуживания = Цел(Объект.ВремяОбслуживания / 5) * 5;
	
	МинимальноеОкончаниеРаботы = Объект.НачалоРаботы + Объект.ВремяОбслуживания * 60;
	Если МинимальноеОкончаниеРаботы > Объект.ОкончаниеРаботы Тогда
		Объект.ОкончаниеРаботы = МинимальноеОкончаниеРаботы;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодЗаполненияПриИзменении(Элемент)
	
	Элементы.ДатаГрафика.НачалоПериодаОтображения 	= ПериодЗаполнения.ДатаНачала;
	Элементы.ДатаГрафика.КонецПериодаОтображения	= ПериодЗаполнения.ДатаОкончания;	
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоРаботыПриИзменении(Элемент)
	
	МинимальноеОкончаниеРаботы = Объект.НачалоРаботы + Объект.ВремяОбслуживания * 60;
	Если МинимальноеОкончаниеРаботы > Объект.ОкончаниеРаботы Тогда
		Объект.ОкончаниеРаботы = МинимальноеОкончаниеРаботы;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеРаботыПриИзменении(Элемент)
	
	МаксимальноеНачалоРаботы = Объект.ОкончаниеРаботы - Объект.ВремяОбслуживания * 60;
	Если МаксимальноеНачалоРаботы < Объект.НачалоРаботы Тогда
		Объект.НачалоРаботы = МаксимальноеНачалоРаботы;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПерерываПриИзменении(Элемент)
	
	МинимальноеОкончаниеПерерыва = Объект.НачалоПерерыва + 900;
	Если МинимальноеОкончаниеПерерыва > Объект.ОкончаниеПерерыва Тогда
		Объект.ОкончаниеПерерыва = МинимальноеОкончаниеПерерыва;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.НачалоПерерыва) Тогда
		Объект.ОкончаниеПерерыва = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПерерываПриИзменении(Элемент)
	
	МаксимальноеНачалоПерерыва = Объект.ОкончаниеПерерыва - 900;
	Если МаксимальноеНачалоПерерыва < Объект.НачалоПерерыва Тогда
		Объект.НачалоПерерыва = МаксимальноеНачалоПерерыва;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ОкончаниеПерерыва) ТОгда
		Объект.НачалоПерерыва = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаГрафикаПриВыводеПериода(Элемент, ОформлениеПериода)
	
	Для Каждого СтрокаОформленияПериода Из ОформлениеПериода.Даты Цикл
		
		Если ДниГрафика.НайтиПоЗначению(СтрокаОформленияПериода.Дата) = Неопределено Тогда
			ЦветТекстаДня = ОбщегоНазначенияКлиент.ЦветСтиля("ВидДняПроизводственногоКалендаряНеУказанЦвет");
		Иначе
			ЦветТекстаДня = ОбщегоНазначенияКлиент.ЦветСтиля("ВидДняПроизводственногоКалендаряРабочийЦвет");
		КонецЕсли;
		СтрокаОформленияПериода.ЦветТекста = ЦветТекстаДня;	
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКлючЗаписи(ВыбранныйДень)
	
	ЗначениеКлюча = Новый Структура;
    ЗначениеКлюча.Вставить("Склад", Объект.Ссылка);
    ЗначениеКлюча.Вставить("День", 	ВыбранныйДень);
	
	Возврат РегистрыСведений.ГрафикРаботыСклада.СоздатьКлючЗаписи(ЗначениеКлюча);
	
КонецФункции	

&НаКлиенте
Процедура ДатаГрафикаВыбор(Элемент, ВыбраннаяДата)
	
	Ключ = ПолучитьКлючЗаписи(ВыбраннаяДата);
	
	Попытка
		ОткрытьФорму("РегистрСведений.ГрафикРаботыСклада.ФормаЗаписи",Новый Структура("Ключ", Ключ));
	Исключение
		Форма = ПолучитьФорму("РегистрСведений.ГрафикРаботыСклада.ФормаЗаписи");
		Форма.Запись.Склад 				= Объект.Ссылка;
		Форма.Запись.День 				= ВыбраннаяДата;
		Форма.Запись.КоличествоОкон 	= Объект.КоличествоОкон;
		Форма.Запись.ВремяОбслуживания 	= Объект.ВремяОбслуживания;
		Форма.Запись.НачалоРаботы 		= Объект.НачалоРаботы;
		Форма.Запись.ОкончаниеРаботы 	= Объект.ОкончаниеРаботы;
		Форма.Запись.НачалоПерерыва		= Объект.НачалоПерерыва;
		Форма.Запись.ОкончаниеПерерыва 	= Объект.ОкончаниеПерерыва;
		Форма.Открыть();		
	КонецПопытки;	
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаГрафикаПриАктивизацииДаты(Элемент)
	
	ЗаполнитьТекущиеПараметры();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьГрафикРаботыНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаписиНаСкладСрезПоследних.День КАК День
	|ПОМЕСТИТЬ ВТ_Записи
	|ИЗ
	|	РегистрСведений.ЗаписиНаСклад.СрезПоследних(
	|			,
	|			Склад = &Склад
	|				И (День МЕЖДУ &НачалоПериода И &ОкончаниеПериода)) КАК ЗаписиНаСкладСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПроизводственногоКалендаря.Дата КАК Дата
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Записи КАК ВТ_Записи
	|		ПО ДанныеПроизводственногоКалендаря.Дата = ВТ_Записи.День
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
	|	И ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И (ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
	|			ИЛИ ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
	|			ИЛИ ВЫБОР
	|				КОГДА НЕ &УчитыватьПраздники
	|					ТОГДА ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Праздник)
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|	И ВТ_Записи.День ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь",	Объект.ПроизводственныйКалендарь);
	Запрос.УстановитьПараметр("НачалоПериода",				ПериодЗаполнения.ДатаНачала);
	Запрос.УстановитьПараметр("ОкончаниеПериода",			ПериодЗаполнения.ДатаОкончания);
	Запрос.УстановитьПараметр("УчитыватьПраздники",			УчитыватьПраздники);
	Запрос.УстановитьПараметр("Склад",						Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "За заданный период производственный календарь не заполнен или существуют записи на склад!";
		СообщениеПользователю.Сообщить();
		Возврат;
		
	КонецЕсли;
	
	ТаблицаЗапроса = Результат.Выгрузить();
	
	Для Каждого СтрокаТаблицыЗапроса Из ТаблицаЗапроса Цикл
		
		НаборЗаписей = РегистрыСведений.ГрафикРаботыСклада.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Склад.Установить(Объект.Ссылка);
		НаборЗаписей.Отбор.День.Установить(СтрокаТаблицыЗапроса.Дата);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
	 	НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьГрафикРаботы(Команда)
	
	ОчиститьГрафикРаботыНаСервере();
	ЗаполнитьДниГрафика();
	
	Элементы.ДатаГрафика.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.НачалоПерерыва) Тогда
		
		Если Объект.НачалоПерерыва < Объект.НачалоРаботы Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Неверно задано время перерыва.";
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
		КонецЕсли;			
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ОкончаниеПерерыва) Тогда
		
		Если Объект.ОкончаниеПерерыва > Объект.ОкончаниеРаботы Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Неверно задано время перерыва.";
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
		КонецЕсли;			
		
	КонецЕсли;
	
КонецПроцедуры
