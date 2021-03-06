#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПриказНаПроведениеМедицинскихОсмотровРабочиеМеста.Ссылка.Дата КАК Период,
	|	ПриказНаПроведениеМедицинскихОсмотровРабочиеМеста.Ссылка.Организация КАК Организация,
	|	ПриказНаПроведениеМедицинскихОсмотровРабочиеМеста.Подразделение КАК Подразделение,
	|	ПриказНаПроведениеМедицинскихОсмотровРабочиеМеста.Должность КАК Должность,
	|	ПриказНаПроведениеМедицинскихОсмотровРабочиеМеста.РабочееМесто КАК РабочееМесто,
	|	ПриказНаПроведениеМедицинскихОсмотровРабочиеМеста.Проводить КАК Проводить
	|ИЗ
	|	Документ.ПриказНаПроведениеМедицинскихОсмотров.РабочиеМеста КАК ПриказНаПроведениеМедицинскихОсмотровРабочиеМеста
	|ГДЕ
	|	ПриказНаПроведениеМедицинскихОсмотровРабочиеМеста.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	
	ТаблицыДляДвижений.Вставить("ТаблицаПриказыНаПроведениеМедицинскихОсмотров", Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

//процедура заполняет табличную часть "Рабочие места"
//Параметры:
//ТекущийОбъект - текущий документ-объект для заполнения
//МассивЗначений - массив выбранных значений
//ПараметрЗаполнения - строка, может принимать значения:
//1. "П"	- заполнение по подразделеням согласно специальной оценке рабочих мест
//2. "Д"	- заполнение по должностям согласно специальной оценке рабочих мест
//3. "РМ" 	- заполнение по рабочим местам согласно специальной оценке рабочих мест
Процедура ЗаполнитьРабочиеМеста(ТекущийОбъект, МассивЗначений, ПараметрЗаполнения) Экспорт
	
	ДатаАнализа = ПроцедурыРаботыСНормамиСервер.ПолучитьГраницуАнализаПоДокументу(ТекущийОбъект.Ссылка);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаАнализа",	ДатаАнализа);
	Запрос.УстановитьПараметр("Организация",	ТекущийОбъект.Организация);	
	Запрос.УстановитьПараметр("МассивЗначений",	МассивЗначений);
		
	Если ПараметрЗаполнения = "П" Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗанятыеРабочиеМестаОстатки.Подразделение КАК Подразделение,
		|	ЗанятыеРабочиеМестаОстатки.Должность КАК Должность,
		|	ЗанятыеРабочиеМестаОстатки.РабочееМесто КАК РабочееМесто,
		|	ИСТИНА КАК Проводить
		|ИЗ
		|	РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(
		|			&ДатаАнализа,
		|			Организация = &Организация
		|				И Подразделение В (&МассивЗначений)) КАК ЗанятыеРабочиеМестаОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.СрезПоследних(&ДатаАнализа, Организация = &Организация) КАК ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних
		|		ПО (ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
		|				ИЛИ ЗанятыеРабочиеМестаОстатки.Подразделение = ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Подразделение)
		|			И (ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
		|				ИЛИ ЗанятыеРабочиеМестаОстатки.Должность = ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Должность)
		|			И (ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РАбочиеМестаАСТБ.ПустаяСсылка)
		|				ИЛИ ЗанятыеРабочиеМестаОстатки.РабочееМесто = ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.РабочееМесто)
		|ГДЕ
		|	НЕ ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.ФакторРабота ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗанятыеРабочиеМестаОстатки.Подразделение.Наименование,
		|	ЗанятыеРабочиеМестаОстатки.Должность.Наименование,
		|	ЗанятыеРабочиеМестаОстатки.РабочееМесто.Наименование";
		
	ИначеЕсли ПараметрЗаполнения = "Д" Тогда	
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗанятыеРабочиеМестаОстатки.Подразделение КАК Подразделение,
		|	ЗанятыеРабочиеМестаОстатки.Должность КАК Должность,
		|	ЗанятыеРабочиеМестаОстатки.РабочееМесто КАК РабочееМесто,
		|	ИСТИНА КАК Проводить
		|ИЗ
		|	РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(
		|			&ДатаАнализа,
		|			Организация = &Организация
		|				И Должность В (&МассивЗначений)) КАК ЗанятыеРабочиеМестаОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.СрезПоследних(&ДатаАнализа, Организация = &Организация) КАК ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних
		|		ПО (ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
		|				ИЛИ ЗанятыеРабочиеМестаОстатки.Подразделение = ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Подразделение)
		|			И (ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
		|				ИЛИ ЗанятыеРабочиеМестаОстатки.Должность = ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Должность)
		|			И (ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РАбочиеМестаАСТБ.ПустаяСсылка)
		|				ИЛИ ЗанятыеРабочиеМестаОстатки.РабочееМесто = ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.РабочееМесто)
		|ГДЕ
		|	НЕ ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.ФакторРабота ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗанятыеРабочиеМестаОстатки.Подразделение.Наименование,
		|	ЗанятыеРабочиеМестаОстатки.Должность.Наименование,
		|	ЗанятыеРабочиеМестаОстатки.РабочееМесто.Наименование";
		
	ИначеЕсли ПараметрЗаполнения = "РМ" Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗанятыеРабочиеМестаОстатки.Подразделение КАК Подразделение,
		|	ЗанятыеРабочиеМестаОстатки.Должность КАК Должность,
		|	ЗанятыеРабочиеМестаОстатки.РабочееМесто КАК РабочееМесто,
		|	ИСТИНА КАК Проводить
		|ИЗ
		|	РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(
		|			&ДатаАнализа,
		|			Организация = &Организация
		|				И РабочееМесто В (&МассивЗначений)) КАК ЗанятыеРабочиеМестаОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.СрезПоследних(&ДатаАнализа, Организация = &Организация) КАК ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних
		|		ПО (ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
		|				ИЛИ ЗанятыеРабочиеМестаОстатки.Подразделение = ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Подразделение)
		|			И (ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИПрофессии.ПустаяСсылка)
		|				ИЛИ ЗанятыеРабочиеМестаОстатки.Должность = ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.Должность)
		|			И (ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РАбочиеМестаАСТБ.ПустаяСсылка)
		|				ИЛИ ЗанятыеРабочиеМестаОстатки.РабочееМесто = ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.РабочееМесто)
		|ГДЕ
		|	НЕ ВредныеИОпасныеФакторыИРаботыНаРабочихМестахСрезПоследних.ФакторРабота ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗанятыеРабочиеМестаОстатки.Подразделение.Наименование,
		|	ЗанятыеРабочиеМестаОстатки.Должность.Наименование,
		|	ЗанятыеРабочиеМестаОстатки.РабочееМесто.Наименование";
		
	Иначе
		
		Возврат;
		
	КонецЕсли;	
		
	ТекущийОбъект.РабочиеМеста.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры	

#КонецЕсли