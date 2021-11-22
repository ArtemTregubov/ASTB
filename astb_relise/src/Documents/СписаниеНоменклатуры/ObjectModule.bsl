#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
//Andrey_NSK***********************************************************************
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаДокумента = Товары.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	УстановитьПривилегированныйРежим(Истина);
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.СписаниеНоменклатуры.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗапасыСерверПереопределяемый.ОтразитьОстаткиНоменклатуры(ДополнительныеСвойства, Движения, Отказ);
   	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	// Контроль выполняется при проведении\отмене проведения не нового документа.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если НЕ Склад.РазрешитьОтрицательныеОстатки Тогда 
			Массив.Добавить(Движения.ОстаткиНоменклатуры);
		КонецЕсли;
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//ПроведениеСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,Отказ,"Товары");	
	
КонецПроцедуры
//Andrey_NSK***********************************************************************

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИнвентаризацияНоменклатуры") И ЭтотОбъект.Товары.Количество() = 0  Тогда
		
		Документы.СписаниеНоменклатуры.ЗаполнитьДокумент(ЭтотОбъект,ДанныеЗаполнения.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли