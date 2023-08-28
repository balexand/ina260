defmodule INA260 do
  defmodule State do
    defstruct [:address, :i2c]
  end

  alias Circuits.I2C

  @default_address 0x40

  @bus_current_register 0x01
  @bus_voltage_register 0x02
  @power_register 0x03

  def open(bus_name, address \\ @default_address) do
    with {:ok, i2c} <- I2C.open(bus_name) do
      {:ok, %State{address: address, i2c: i2c}}
    end
  end

  def read_bus_current(%State{address: address, i2c: i2c}) do
    with {:ok, raw} <- I2C.write_read(i2c, address, <<@bus_current_register>>, 2) do
      <<current::signed-16>> = raw
      {:ok, current * 0.00125}
    end
  end

  def read_bus_voltage(%State{address: address, i2c: i2c}) do
    with {:ok, raw} <- I2C.write_read(i2c, address, <<@bus_voltage_register>>, 2) do
      <<current::unsigned-16>> = raw
      {:ok, current * 0.00125}
    end
  end

  def read_power(%State{address: address, i2c: i2c}) do
    with {:ok, raw} <- I2C.write_read(i2c, address, <<@power_register>>, 2) do
      <<current::unsigned-16>> = raw
      {:ok, current * 0.01}
    end
  end
end
