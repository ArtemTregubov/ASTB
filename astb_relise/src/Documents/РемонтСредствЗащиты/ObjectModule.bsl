#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаДокумента = Ремонт.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	УстановитьПривилегированныйРежим(Истина);
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.РемонтСредствЗащиты.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗапасыСерверПереопределяемый.ОтразитьРемонтСредствЗащиты(ДополнительныеСвойства, Движения, Отказ);
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	// Контроль выполняется при проведении\отмене проведения не нового документа.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если ВидОперации = Перечисления.ВидыОперацийРемонтаСИЗ.ВозвратИзРемонта Тогда
			Массив.Добавить(Движения.РемонтСредствЗащиты);
		КонецЕсли;	
	КонецЕсли;	

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		
		Документы.РемонтСредствЗащиты.ЗаполнитьДокумент(ДанныеЗаполнения,ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли