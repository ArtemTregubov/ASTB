// Функция выполняет подключение внешней компоненты и ее первоначальную настройку.
// Возвращаемое значение: НЕОПРЕДЕЛЕНО - компоненту не удалось загрузить
Функция ПодключитьВнешнююКомпонентуПечатиШтрихкода() Экспорт
	
	ПодключениеВыполнено = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаПечатиШтрихкодов", "КартинкаШтрихкода", ТипВнешнейКомпоненты.Native);
	
	// Создадим объект внешней компоненты
	Если ПодключениеВыполнено Тогда
		ВнешняяКомпонента = Новый("AddIn.КартинкаШтрихкода.Barcode");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	// Если нет возможности рисовать
	Если НЕ ВнешняяКомпонента.ГрафикаУстановлена Тогда
		// То картинку сформировать не сможем
		Возврат Неопределено;
	Иначе
		// Установим основные параметры компоненты
		// Если в системе установлен шрифт Tahoma
		Если ВнешняяКомпонента.НайтиШрифт("Tahoma") = Истина Тогда
			// Выбираем его как шрифт для формирования картинки
			ВнешняяКомпонента.Шрифт = "Tahoma";
		Иначе
			// Шрифт Tahoma в системе отсутствует
			// Обойдем все доступные компоненте шрифты
			Для Сч = 0 По ВнешняяКомпонента.КоличествоШрифтов -1 Цикл
				// Получим очередной шрифт, доступный компоненте
				ТекущийШрифт = ВнешняяКомпонента.ШрифтПоИндексу(Сч);
				// Если шрифт доступен
				Если ТекущийШрифт <> Неопределено Тогда
					// Они и будет шрифтом для формирования штрихкода
					ВнешняяКомпонента.Шрифт = ТекущийШрифт;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		// Установим размер шрифта
		ВнешняяКомпонента.РазмерШрифта = 12;
		
		Возврат ВнешняяКомпонента;
	КонецЕсли;
	
КонецФункции
