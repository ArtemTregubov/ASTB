
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВыполнитьЗагрузкуНаСервере();
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ДопустимыеЗначенияАнтропометрическихСвойств"));
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗагрузкуНаСервере()
	
	РегистрыСведений.ДопустимыеЗначенияАнтропометрическихСвойств.ВыполнитьЗагрузкуДопустимыхЗначенийАнтропометрии();
	
КонецПроцедуры