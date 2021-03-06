//АСТБ_Горюшин_Алексей_17125

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаДокумента = Товары.Итог("Сумма");
	
КонецПроцедуры 

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	// Контроль выполняется при проведении\отмене проведения не нового документа.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Массив.Добавить(Движения.РеализованныеСИЗ);
		
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЭтотОбъект.Товары.Очистить();
	
КонецПроцедуры 

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ПредварительныйПереходПраваСобственности.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗапасыСерверПереопределяемый.ОтразитьРеализованныеСИЗ(ДополнительныеСвойства, Движения, Отказ);
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецЕсли
